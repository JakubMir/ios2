import SpriteKit
internal import GameplayKit

protocol GameSceneDelegate: AnyObject {
    func swipeHandler(_ swap: Swap, completion: @escaping (Bool) -> Void)
}

class GameScene: SKScene {
    
    var level: Level!
    weak var swipeDelegate: GameSceneDelegate?
    
    var tileWidth: CGFloat = 34.0
    var tileHeight: CGFloat = 36.0
    
    let gameLayer = SKNode()
    let backgroundLayer = SKNode()
    let cookiesLayer = SKNode()
    
    lazy var stateMachine: GKStateMachine = {
        let states = [
            WaitForInputState(scene: self),
            AnimatingState(scene: self)
        ]
        return GKStateMachine(states: states)
    }()
    
    private var swipeFromColumn: Int?
    private var swipeFromRow: Int?
    
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = .clear
        
        addChild(gameLayer)
        gameLayer.addChild(backgroundLayer)
        gameLayer.addChild(cookiesLayer)
        
        // 1. Vypočítáme rozměry a pozicujeme vrstvy
        updateLayout()
        
        // 2. Vykreslíme mřížku (respektující díry)
        createGridBackground()
        
        stateMachine.enter(WaitForInputState.self)
    }
    
    // Centrální místo pro výpočet velikosti dlaždic
    func updateLayout() {
        let totalWidth = self.size.width
        let totalSpacing: CGFloat = 20.0
        let availableWidth = totalWidth - totalSpacing
        
        // Aktualizujeme globální proměnnou
        let newTileSize = availableWidth / CGFloat(NumColumns)
        tileWidth = newTileSize
        tileHeight = newTileSize
        
        // Vycentrujeme vrstvy
        let layerPosition = CGPoint(
            x: -tileWidth * CGFloat(NumColumns) / 2,
            y: -tileHeight * CGFloat(NumRows) / 2)
        
        backgroundLayer.position = layerPosition
        cookiesLayer.position = layerPosition
    }
    
    func createGridBackground() {
        backgroundLayer.removeAllChildren()
        
        for row in 0..<NumRows {
            for col in 0..<NumColumns {
                
                // OPRAVA 2: Ptáme se levelu, jestli je tu platné políčko
                if level?.isTileValid(column: col, row: row) == true {
                    
                    let tileNode = SKShapeNode(rectOf: CGSize(width: tileWidth, height: tileHeight))
                    tileNode.fillColor = UIColor.black.withAlphaComponent(0.2)
                    tileNode.strokeColor = .clear
                    tileNode.position = pointFor(column: col, row: row)
                    
                    backgroundLayer.addChild(tileNode)
                }
            }
        }
    }
    
    func addSprites(for cookies: Set<GameCookie>) {
        cookiesLayer.removeAllChildren()
        
        // POJISTKA PROTI DRIFTU:
        // Pokud se addSprites zavolá dřív než didMove (nebo se změnila velikost),
        // ujistíme se, že layout je aktuální.
        if tileWidth == 34.0 || cookiesLayer.position == .zero {
            updateLayout()
            // Pokud jsme změnili layout, musíme překreslit i mřížku, aby seděla
            createGridBackground()
        }
        
        for cookie in cookies {
            let sprite = SKSpriteNode(imageNamed: "\(cookie.cookieType)")
            sprite.size = CGSize(width: tileWidth * 0.9, height: tileHeight * 0.9)
            sprite.position = pointFor(column: cookie.column, row: cookie.row)
            cookiesLayer.addChild(sprite)
            cookie.sprite = sprite
            
            sprite.alpha = 0
            sprite.run(.fadeIn(withDuration: 0.3))
        }
    }
    
    func pointFor(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column) * tileWidth + tileWidth / 2,
            y: CGFloat(row) * tileHeight + tileHeight / 2)
    }
    
    func convertPoint(_ point: CGPoint) -> (success: Bool, column: Int, row: Int) {
        if point.x >= 0 && point.x < CGFloat(NumColumns) * tileWidth &&
           point.y >= 0 && point.y < CGFloat(NumRows) * tileHeight {
            return (true, Int(point.x / tileWidth), Int(point.y / tileHeight))
        } else {
            return (false, 0, 0)
        }
    }
    
    func deselectCookie() {
        if let col = swipeFromColumn, let row = swipeFromRow,
           let cookie = level?.cookieAt(column: col, row: row),
           let sprite = cookie.sprite {
            sprite.removeAllActions()
            sprite.run(.scale(to: 1.0, duration: 0.15))
        }
        swipeFromColumn = nil
        swipeFromRow = nil
    }
    
    // --- OVLÁDÁNÍ ---
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard stateMachine.currentState is WaitForInputState else { return }
        guard let touch = touches.first else { return }
        let location = touch.location(in: cookiesLayer)
        let (success, col, row) = convertPoint(location)
        if success {
            if let cookie = level?.cookieAt(column: col, row: row) {
                swipeFromColumn = col
                swipeFromRow = row
                if let sprite = cookie.sprite {
                    sprite.run(.scale(to: 1.2, duration: 0.15), withKey: "pickup")
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard stateMachine.currentState is WaitForInputState else { return }
        guard let startCol = swipeFromColumn, let startRow = swipeFromRow else { return }
        guard let touch = touches.first else { return }
        let location = touch.location(in: cookiesLayer)
        let (success, col, row) = convertPoint(location)
        if success {
            var horzDelta = 0, vertDelta = 0
            if col < startCol { horzDelta = -1 } else if col > startCol { horzDelta = 1 } else if row < startRow { vertDelta = -1 } else if row > startRow { vertDelta = 1 }
            if horzDelta != 0 || vertDelta != 0 { trySwap(horizontal: horzDelta, vertical: vertDelta) }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { deselectCookie() }
    
    private func trySwap(horizontal: Int, vertical: Int) {
        guard let startCol = swipeFromColumn, let startRow = swipeFromRow else { return }
        let toColumn = startCol + horizontal; let toRow = startRow + vertical
        guard toColumn >= 0 && toColumn < NumColumns && toRow >= 0 && toRow < NumRows else { return }
        
        if let toCookie = level.cookieAt(column: toColumn, row: toRow), let fromCookie = level.cookieAt(column: startCol, row: startRow) {
            stateMachine.enter(AnimatingState.self)
            let swap = Swap(cookieA: fromCookie, cookieB: toCookie)
            
            if let sA = fromCookie.sprite { sA.removeAllActions(); sA.run(.scale(to: 1.0, duration: 0.1)) }
            if let sB = toCookie.sprite { sB.removeAllActions(); sB.run(.scale(to: 1.0, duration: 0.1)) }
            
            swipeDelegate?.swipeHandler(swap) { success in
                if !success { self.animateInvalidSwap(swap) { self.stateMachine.enter(WaitForInputState.self) } }
            }
        }
    }
    
    func animateSwap(_ swap: Swap, completion: @escaping () -> Void) {
        let spriteA = swap.cookieA.sprite!; let spriteB = swap.cookieB.sprite!
        spriteA.zPosition = 100; spriteB.zPosition = 90
        let moveA = SKAction.move(to: spriteB.position, duration: 0.3); moveA.timingMode = .easeOut
        let moveB = SKAction.move(to: spriteA.position, duration: 0.3); moveB.timingMode = .easeOut
        spriteA.run(moveA, completion: completion); spriteB.run(moveB)
    }
    
    func animateInvalidSwap(_ swap: Swap, completion: @escaping () -> Void) {
        let spriteA = swap.cookieA.sprite!; let spriteB = swap.cookieB.sprite!
        spriteA.zPosition = 100; spriteB.zPosition = 90
        let moveA = SKAction.move(to: spriteB.position, duration: 0.2); moveA.timingMode = .easeOut
        let moveB = SKAction.move(to: spriteA.position, duration: 0.2); moveB.timingMode = .easeOut
        spriteA.run(moveA, completion: completion); spriteB.run(moveB)
    }
    
    func animateMatchedCookies(for chains: Set<Chain>, completion: @escaping () -> Void) {
        for chain in chains {
            for cookie in chain.cookies {
                if let sprite = cookie.sprite, sprite.action(forKey: "removing") == nil {
                    let scale = SKAction.scale(to: 0.1, duration: 0.3); scale.timingMode = .easeOut
                    sprite.run(SKAction.sequence([scale, SKAction.removeFromParent()]), withKey: "removing")
                }
            }
        }
        run(SKAction.wait(forDuration: 0.3), completion: completion)
    }
    
    // --- ANIMACE PADÁNÍ ---
    func animateFallingCookies(columns: [[GameCookie]], completion: @escaping () -> Void) {
        var longestDuration: TimeInterval = 0
        let baseStartY = pointFor(column: 0, row: NumRows).y // Start nad obrazovkou
        
        for array in columns {
            var newCookieIndex = 0
            for (index, cookie) in array.enumerated() {
                let newPosition = pointFor(column: cookie.column, row: cookie.row)
                let delay = 0.05 + 0.1 * TimeInterval(index)
                let startY: CGFloat; let duration: TimeInterval
                
                if cookie.sprite == nil {
                    let sprite = SKSpriteNode(imageNamed: "\(cookie.cookieType)")
                    sprite.size = CGSize(width: tileWidth * 0.9, height: tileHeight * 0.9)
                    startY = baseStartY + (CGFloat(newCookieIndex) * tileHeight)
                    newCookieIndex += 1
                    sprite.position = CGPoint(x: newPosition.x, y: startY)
                    cookiesLayer.addChild(sprite)
                    cookie.sprite = sprite
                    duration = 0.4
                } else {
                    startY = cookie.sprite!.position.y
                    duration = 0.2
                }
                
                let moveAction = SKAction.move(to: newPosition, duration: duration); moveAction.timingMode = .easeOut
                longestDuration = max(longestDuration, duration + delay)
                cookie.sprite?.run(SKAction.sequence([SKAction.wait(forDuration: delay), SKAction.group([moveAction, SKAction.fadeIn(withDuration: 0.1)])]))
            }
        }
        run(SKAction.wait(forDuration: longestDuration), completion: completion)
    }
    
    func resetSelection() { swipeFromColumn = nil; swipeFromRow = nil }
}
