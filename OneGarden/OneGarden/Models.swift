//
//  Models.swift
//  OneGarden
//
//  Created by Adam Boyher on 9/2/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Plant {
    var id: UUID = UUID()
    var name: String
    var variety: String
    var themeColor: String
    @Relationship(deleteRule: .cascade, inverse: \Note.plant)
    var notes: [Note] = []
    
    init(name: String, variety: String = "", themeColor: Color) {
        self.name = name
        self.variety = variety
        self.themeColor = themeColor.toHex() ?? "#FFFFFF"
    }
}

@Model
class Note {
    @Attribute(.unique) var id: UUID = UUID()
    var title: String
    var content: String
    var plant: Plant?
    
    init(title: String = "", content: String = "", plant: Plant? = nil) {
        self.title = title
        self.content = content
        self.plant = plant
    }
}


extension Color {
    func toHex() -> String? {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let r = Int(red * 255)
        let g = Int(green * 255)
        let b = Int(blue * 255)
        let hexString = String(format: "#%02X%02X%02X", r, g, b)
        
        return hexString
    }
}

extension Color {
    init(hex: String) {
        // Remove the hash if it exists
        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        
        // Ensure the string is the correct length
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        let red, green, blue: Double
        let alpha: Double
        
        if hexString.count == 6 {
            red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
            green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
            blue = Double(rgbValue & 0x0000FF) / 255.0
            alpha = 1.0
        } else if hexString.count == 8 {
            red = Double((rgbValue & 0xFF000000) >> 24) / 255.0
            green = Double((rgbValue & 0x00FF0000) >> 16) / 255.0
            blue = Double((rgbValue & 0x0000FF00) >> 8) / 255.0
            alpha = Double(rgbValue & 0x000000FF) / 255.0
        } else {
            red = 0.0
            green = 0.0
            blue = 0.0
            alpha = 1.0
        }
        
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}

extension Color {
    func readableTextColor() -> Color {
        // Convert the Color to a UIColor to extract the components
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        // Get the RGB components of the color
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // Calculate the luminance of the color
        let luminance = (0.299 * red + 0.587 * green + 0.114 * blue)
        
        // Return black or white depending on luminance
        return luminance > 0.7 ? .black : .white
    }
}
