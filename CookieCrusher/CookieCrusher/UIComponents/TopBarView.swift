//
//  TopBarView.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 28.12.2025.
//

import Combine
import SwiftUI

struct TopBarView: View {
  var lives: Int = 5
  var currency: Int = 150
  var lastLifeLost: Date?

  var onTimerExpired: (() -> Void)?

  @State private var timeString: String = ""

  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

  let regenInterval: TimeInterval = 300

  var body: some View {
    HStack {
      NavigationLink(destination: LeaderboardView()) {
        Image("Buttons-trophy").resizable().scaledToFit().frame(width: 50, height: 70)
      }

      Spacer()

      // Lives
      HStack(spacing: 4) {
        ZStack {
          Image(systemName: "heart.fill")
            .foregroundColor(.pink)
            .font(.largeTitle)

          Text("\(lives)")
            .font(.title3)
            .bold()
            .foregroundColor(.white)
            .shadow(radius: 1)
        }

        if lives < 5 {
          Text(timeString)
            .font(.caption)
            .bold()
            .foregroundColor(.white)
            .monospacedDigit()
            .frame(width: 45, alignment: .leading)
        }
      }.padding(.horizontal, 15)
        .padding(.vertical, 8)
        .background(Color.black.opacity(0.5))
        .cornerRadius(20)

      //Spacer()
        
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
              .font(.largeTitle)

            Text("\(currency)")
              .font(.title3)
              .bold()
              .foregroundColor(.white)
              .shadow(radius: 1)

        }.padding(.horizontal, 12)
          .padding(.vertical, 5)
          .background(Color.black.opacity(0.5))
          .cornerRadius(20)
        
        Spacer()

      NavigationLink(destination: SettingsMenuView()) {
        Image("Buttons-setting").resizable().scaledToFit().frame(width: 50, height: 70)
      }

    }
    .padding(.horizontal)
    .background(Color("Primary"))
    .onReceive(timer) { _ in
      updateTimer()
    }
    .onAppear {
      updateTimer()
    }
  }

  private func updateTimer() {
    guard lives < 5, let start = lastLifeLost else {
      timeString = ""
      return
    }

    let targetDate = start.addingTimeInterval(regenInterval)

    let diff = targetDate.timeIntervalSince(Date())

    if diff > 0 {
      let minutes = Int(diff) / 60
      let seconds = Int(diff) % 60
      timeString = String(format: "%02d:%02d", minutes, seconds)
    } else {
      timeString = "00:00"
      onTimerExpired?()
    }
  }
}

#Preview {
  TopBarView()
}
