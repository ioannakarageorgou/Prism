//
//  Palette.swift
//  Prism
//
//  Created by Ioanna Karageorgou on 30/10/26.
//

import SwiftUI

enum Palette: String, CaseIterable, Identifiable {
    case crystal, neon, aurora

    var id: Self { self }

    var colors: [Color] {
        switch self {
        case .crystal:
            // Icy whites and pale blues: light through glass
            [Color(red: 0.90, green: 0.97, blue: 1.00),
             Color(red: 0.55, green: 0.80, blue: 1.00),
             Color(red: 0.78, green: 0.70, blue: 1.00)]
        case .neon:
            // Saturated magenta, cyan and violet: city lights at night
            [Color(red: 1.00, green: 0.20, blue: 0.75),
             Color(red: 0.10, green: 0.90, blue: 1.00),
             Color(red: 0.55, green: 0.30, blue: 1.00)]
        case .aurora:
            // Greens and teals with a touch of pink: northern lights
            [Color(red: 0.30, green: 1.00, blue: 0.60),
             Color(red: 0.15, green: 0.75, blue: 0.85),
             Color(red: 1.00, green: 0.45, blue: 0.75)]
        }
    }
}
