//
//  GradientView.swift
//  example-ios
//
//  Created by Рафаэль Голубев on 10.01.2025.
//

import SwiftUI

struct GradientView: View {
    let size = CGSize(width: 300, height: 200)

    let startDate = Date() // Сохранили время первой отрисовки

    var body: some View {
        TimelineView(.animation) { _ in // Заставляем элементы перерисовываться от времени
            Rectangle()
                .foregroundColor(.blue)
                .frame(width: size.width, height: size.height)
                .colorEffect(
                    ShaderLibrary.animatedGradient(
                        .float(size.width),
                        .float(startDate.timeIntervalSinceNow) // Передаем разницу
                    )
                  )
        }
    }
}

#Preview {
    GradientView()
}
