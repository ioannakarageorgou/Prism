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

            Canvas {
                context,
                size in
                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                let now: TimeInterval = 0.5
                
                let particles = [
                    Particle(
                        startPosition: center,
                        velocity: CGVector(dx: 100, dy: 0),
                        birthTime: 0,
                        lifetime: 2,
                        radius: 10,
                        color: .red
                    ),
                    Particle(
                        startPosition: center,
                        velocity: CGVector(dx: 0, dy: -100),
                        birthTime: 0,
                        lifetime: 2,
                        radius: 10,
                        color: .cyan
                    ),
                    Particle(
                        startPosition: center,
                        velocity: CGVector(dx: -80, dy: 80),
                        birthTime: 0,
                        lifetime: 2,
                        radius: 10,
                        color: .yellow
                    )
                ]

                for particle in particles where particle.isAlive(at: now) {
                    let point = particle.position(at: now)
                    let r = particle.radius
                    let rect = CGRect(x: point.x - r, y: point.y - r, width: r * 2, height: r * 2)
                    let color = particle.color.opacity(particle.opacity(at: now))
                    context.fill(Circle().path(in: rect), with: .color(color))
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
