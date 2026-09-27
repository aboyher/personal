//
//  Theme.swift
//  Enchanted Garden
//
//  Created by Adam Boyher on 7/1/24.
//

import Foundation
import SwiftUI

struct EnchantedTheme {
    static let deepForestGreen = Color(hex: "1E3B2C")
    static let richPurple = Color(hex: "733D8B")
    static let paleGold = Color(hex: "E6D0A5")
    static let lightGreen = Color(hex: "7BAA7F")
    static let darkPurple = Color(hex: "3D2645")
    
    static let background = deepForestGreen
    static let accent = richPurple
    static let text = paleGold
    static let secondaryBackground = darkPurple
    static let highlight = lightGreen
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
