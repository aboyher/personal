//
//  Baby.swift
//  TrackBaby
//
//  Created by Adam Boyher on 6/8/24.
//

import Foundation
import SwiftData

enum Gender: Codable, CaseIterable {
    case Boy, Girl
}

@Model
class Baby: Identifiable, Hashable {
    var id: UUID
    var profile: Profile
    var name: String
    var gender: Gender
    var theme: Theme
    
    init(id: UUID = UUID(), profile: Profile, name: String, gender: Gender, theme: Theme = .bubblegum) {
        self.id = id
        self.profile = profile
        self.name = name
        self.gender = gender
        self.theme = theme
    }
}
