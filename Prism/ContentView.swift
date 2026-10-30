//
//  ContentView.swift
//  Prism
//
//  Created by Ioanna Karageorgou on 29/10/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.black

            Canvas { context, size in
                let radius: CGFloat = 10
                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                let rect = CGRect(
                    x: center.x - radius,
                    y: center.y - radius,
                    width: radius * 2,
                    height: radius * 2
                )

                let path = Circle().path(in: rect)
                context.fill(path, with: .color(.red))
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
