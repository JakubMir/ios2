//
//  LoadingProgressStyle.swift
//  CityGuide
//
//  Created by Matej Molnár on 06.11.2025.
//

import SwiftUI

struct LoadingProgressStyle: ProgressViewStyle {
    @State var isLoading = false

    func makeBody(configuration: Configuration) -> some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(
                Color.blue,
                style: StrokeStyle(
                    lineWidth: 8,
                    lineCap: .round
                )
            )
            .frame(width: 80, height: 80)
            .rotationEffect(
                .degrees(isLoading ? 360 : 0)
            )
            .onAppear {
                withAnimation(
                    .linear(duration: 0.7)
                    .repeatForever(autoreverses: false)
                ) {
                    isLoading = true
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(25)
    }
}


extension ProgressViewStyle where Self == LoadingProgressStyle {
    static var loading: LoadingProgressStyle { LoadingProgressStyle() }
}

#Preview {
    ProgressView()
        .progressViewStyle(.loading)
}
