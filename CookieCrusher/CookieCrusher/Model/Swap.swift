//
//  Swap.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 02.01.2026.
//

struct Swap: CustomStringConvertible {
    let cookieA: GameCookie
    let cookieB: GameCookie
    
    var description: String {
        return "swap \(cookieA) with \(cookieB)"
    }
}
