//
//  ParticleSystem.swift
//  Prism
//
//  Created by Ioanna Karageorgou on 30/10/26.
//

import SwiftUI

struct ParticleSystem {
    private(set) var particles: [Particle] = []

    private let maxParticles = 1500
    var palette: Palette = .neon

    // A few slow particles drifting away from the finger
    mutating func emitTrail(at point: CGPoint, time: TimeInterval) {
        for _ in 0..<5 {
            particles.append(Particle(
                startPosition: point,
                velocity: CGVector(dx: .random(in: -20...20), dy: .random(in: -20...20)),
                birthTime: time,
                lifetime: .random(in: 1.2...2.2),
                radius: .random(in: 3...6),
                color: palette.colors.randomElement() ?? .white,
                gravity: 20
            ))
        }
        removeExpired(at: time)
    }

    // Particles flying outward in every direction
    mutating func burst(at point: CGPoint, time: TimeInterval) {
        for _ in 0..<80 {
            let angle = Double.random(in: 0..<2 * .pi)
            let speed = Double.random(in: 100...400)
            particles.append(Particle(
                startPosition: point,
                velocity: CGVector(dx: cos(angle) * speed, dy: sin(angle) * speed),
                birthTime: time,
                lifetime: .random(in: 0.6...1.4),
                radius: .random(in: 2...5),
                color: palette.colors.randomElement() ?? .white,
                gravity: 200
            ))
        }
        removeExpired(at: time)
    }

    // Remove every particle at once
    mutating func clear() {
        particles.removeAll()
    }

    // Drop dead particles, then keep only the newest maxParticles
    private mutating func removeExpired(at time: TimeInterval) {
        particles.removeAll { !$0.isAlive(at: time) }
        if particles.count > maxParticles {
            particles.removeFirst(particles.count - maxParticles)
        }
    }
}
