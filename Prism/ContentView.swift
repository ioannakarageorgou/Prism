//
//  ContentView.swift
//  Prism
//
//  Created by Ioanna Karageorgou on 29/10/26.
//

import SwiftUI

struct ContentView: View {
    @State private var system = ParticleSystem()
    @State private var symmetry: Int = 1   // 1 = off, 6 = kaleidoscope

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
                    let center = CGPoint(x: size.width / 2, y: size.height / 2)

                    for particle in system.particles where particle.isAlive(at: now) {
                        let point = particle.position(at: now)
                        let alpha = particle.opacity(at: now)
                        let glowRadius = particle.radius * 4

                        // Draw the particle at its position AND all its mirror positions
                        let drawPoints = kaleidoscopePoints(for: point, center: center, segments: symmetry)

                        for drawPoint in drawPoints {
                            // Soft halo
                            context.fill(
                                dot(at: drawPoint, radius: glowRadius),
                                with: .radialGradient(
                                    Gradient(colors: [particle.color.opacity(alpha * 0.5), particle.color.opacity(0)]),
                                    center: drawPoint,
                                    startRadius: 0,
                                    endRadius: glowRadius
                                )
                            )

                            // Bright core
                            context.fill(
                                dot(at: drawPoint, radius: particle.radius),
                                with: .color(particle.color.opacity(alpha))
                            )
                        }
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

            Button {
                symmetry = symmetry == 1 ? 6 : 1
            } label: {
                Image(systemName: symmetry == 1 ? "hexagon" : "hexagon.fill")
                    .font(.title3)
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
            }
            .accessibilityLabel(symmetry == 1 ? "Symmetry off" : "Symmetry on")
            .sensoryFeedback(.impact, trigger: symmetry)

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
        .animation(.snappy, value: symmetry)
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

    // Given one point, return that point plus (segments - 1) rotated/reflected mirrors,
    // all arranged symmetrically around the screen center.
    private func kaleidoscopePoints(
        for point: CGPoint,
        center: CGPoint,
        segments: Int
    ) -> [CGPoint] {
        guard segments > 1 else { return [point] }

        // Translate the point into polar coordinates relative to center
        let dx = point.x - center.x
        let dy = point.y - center.y
        let radius = sqrt(dx * dx + dy * dy)   // distance from center
        let baseAngle = atan2(dy, dx)           // direction from center

        let step = (2 * Double.pi) / Double(segments) // angle between each mirror

        return (0..<segments).flatMap { i in
            let angle = baseAngle + Double(i) * step

            // Rotated copy
            let rotated = CGPoint(
                x: center.x + radius * cos(angle),
                y: center.y + radius * sin(angle)
            )

            // Reflected copy (flip across the rotated axis)
            let reflectedAngle = Double(i) * step - (baseAngle - Double(i) * step)
            let reflected = CGPoint(
                x: center.x + radius * cos(reflectedAngle),
                y: center.y + radius * sin(reflectedAngle)
            )

            return [rotated, reflected]
        }
    }
}

#Preview {
    ContentView()
}
