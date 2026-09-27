//
//  Models.swift
//  Enchanted Garden
//
//  Created by Adam Boyher on 7/1/24.
//

import Foundation
import SwiftData

@Model
final class Plant {
    var name: String
    var species: String
    var plantingDate: Date
    var location: String
    var notes: String?
    var growthUpdates: [GrowthUpdate]?
    
    init(name: String, species: String, plantingDate: Date, location: String, notes: String? = nil) {
        self.name = name
        self.species = species
        self.plantingDate = plantingDate
        self.location = location
        self.notes = notes
        self.growthUpdates = []
    }
}

@Model
final class GrowthUpdate {
    var date: Date
    var note: String
    var photoURL: URL?
    
    init(date: Date, note: String, photoURL: URL? = nil) {
        self.date = date
        self.note = note
        self.photoURL = photoURL
    }
}
