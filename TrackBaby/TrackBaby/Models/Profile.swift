//
//  Profile.swift
//  TrackBaby
//
//  Created by Adam Boyher on 6/7/24.
//

import Foundation
import SwiftData

@Model
class Profile{
    let name: String
    let parentType: ParentType
    let age: Int
    @Relationship(deleteRule: .cascade, inverse: \Baby.profile)
    var babies: [Baby] = [Baby]()
    var selectedBaby: Baby?
    
    init(name: String, parentType: ParentType, age: Int) {
        self.name = name
        self.parentType = parentType
        self.age = age
    }
}

enum ParentType: String, CaseIterable, Codable, Identifiable {
    case Dad = "Dad"
    case Mom = "Mom"
    
    var id: String { self.rawValue }
    
}
