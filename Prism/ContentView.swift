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
        ZStack(alignment: .bottom) {
            particleCanvas
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

            controlBar
                .padding(.bottom, 8)
        }
    }

    private var particleCanvas: some View {
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
    }

    private var controlBar: some View {
        HStack(spacing: 16) {
            ForEach(Palette.allCases) { palette in
                Button {
                    system.palette = palette
                } label: {
                    Circle()
                        .fill(LinearGradient(colors: palette.colors, startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 32, height: 32)
                        .padding(4)
                        .overlay {
                            Circle()
                                .strokeBorder(.white, lineWidth: 2)
                                .opacity(system.palette == palette ? 1 : 0)
                        }
                }
                .accessibilityLabel(palette.rawValue.capitalized)
                .accessibilityAddTraits(system.palette == palette ? .isSelected : [])
            }

            Divider()
                .frame(height: 28)

            Button {
                system.clear()
            } label: {
                Image(systemName: "trash")
                    .font(.title3)
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
            }
            .accessibilityLabel("Clear")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .glassEffect()
        .animation(.snappy, value: system.palette)
        .sensoryFeedback(.selection, trigger: system.palette)
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
