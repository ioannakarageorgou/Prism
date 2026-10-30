//
//  Particle.swift
//  Prism
//
//  Created by Ioanna Karageorgou on 30/10/26.
//

import SwiftUI

struct Particle {
    var startPosition: CGPoint
    var velocity: CGVector
    var birthTime: TimeInterval
    var lifetime: TimeInterval
    var radius: CGFloat
    var color: Color
    // Downward pull in points/second² (screen y grows downward, so positive = falls)
    var gravity: CGFloat = 0

    // now − birthTime
    func age(at time: TimeInterval) -> TimeInterval {
        time - birthTime
    }

    // age ≥ 0 and age < lifetime
    func isAlive(at time: TimeInterval) -> Bool {
        let age = self.age(at: time)
        return age >= 0 && age < lifetime
    }

    //  age ÷ lifetime
    func progress(at time: TimeInterval) -> Double {
        age(at: time) / lifetime
    }

    // 1 − progress
    func opacity(at time: TimeInterval) -> Double {
        let value = 1 - progress(at: time)
        return min(max(value, 0), 1)
    }

    // position = start + speed × time
    // y also gets + ½ × gravity × time², which makes the fall speed up (an arc, not a line)
    func position(at time: TimeInterval) -> CGPoint {
        let age = self.age(at: time)
        return CGPoint(
            x: startPosition.x + velocity.dx * age,
            y: startPosition.y + velocity.dy * age + 0.5 * gravity * age * age
        )
    }
}
