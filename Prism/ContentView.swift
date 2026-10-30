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
                    for particle in system.particles where particle.isAlive(at: now) {
                        let point = particle.position(at: now)
                        let r = particle.radius
                        let rect = CGRect(x: point.x - r, y: point.y - r, width: r * 2, height: r * 2)
                        let color = particle.color.opacity(particle.opacity(at: now))
                        context.fill(Circle().path(in: rect), with: .color(color))
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
}

#Preview {
    ContentView()
}
