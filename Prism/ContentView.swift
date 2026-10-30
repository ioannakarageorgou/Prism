//
//  ContentView.swift
//  Prism
//
//  Created by Ioanna Karageorgou on 29/10/26.
//

import SwiftUI

struct ContentView: View {
    @State private var system = ParticleSystem()

    var body: some View {
        ZStack {
            Color.black

            TimelineView(.animation) { timeline in
                let now = timeline.date.timeIntervalSinceReferenceDate

                Canvas { context, size in
                    context.blendMode = .plusLighter

                    for particle in system.particles where particle.isAlive(at: now) {
                        let point = particle.position(at: now)
                        let alpha = particle.opacity(at: now)
                        let glowRadius = particle.radius * 4

                        // Soft halo: particle color in the center, fading to transparent at the edge
                        context.fill(
                            dot(at: point, radius: glowRadius),
                            with: .radialGradient(
                                Gradient(colors: [particle.color.opacity(alpha * 0.5), particle.color.opacity(0)]),
                                center: point,
                                startRadius: 0,
                                endRadius: glowRadius
                            )
                        )

                        // Bright core
                        context.fill(
                            dot(at: point, radius: particle.radius),
                            with: .color(particle.color.opacity(alpha))
                        )
                    }
                }
            }
        }
        .ignoresSafeArea()
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    system.emitTrail(at: value.location, time: Date.now.timeIntervalSinceReferenceDate)
                }
                .onEnded { value in
                    let distance = hypot(value.translation.width, value.translation.height)
                    if distance < 10 {
                        system.burst(at: value.location, time: Date.now.timeIntervalSinceReferenceDate)
                    }
                }
        )
    }

    // A circle path centered on a point
    private func dot(at center: CGPoint, radius: CGFloat) -> Path {
        Circle().path(in: CGRect(
            x: center.x - radius,
            y: center.y - radius,
            width: radius * 2,
            height: radius * 2
        ))
    }
}

#Preview {
    ContentView()
}
