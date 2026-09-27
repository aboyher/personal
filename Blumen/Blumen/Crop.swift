//
//  Crop.swift
//  Blumen
//
//  Created by Adam Boyher on 7/22/24.
//

import Foundation
import SwiftData

@Model
final class Crop {
    var id: UUID = UUID()
    var name: String
    var plantDate: Date
    var quantity: Int
    @Relationship(deleteRule: .cascade) var entries: [Entry] = []
    
    init(name: String, plantDate: Date, quantity: Int) {
        self.name = name
        self.plantDate = plantDate
        self.quantity = quantity
    }
}

@Model
final class Entry {
    var id: UUID = UUID()
    var timestamp: Date
    var type: EntryType
    var content: String
    var photoData: Data?
    var caption: String?
    
    @Relationship(inverse: \Crop.entries) var crop: Crop?
    
    init(timestamp: Date, type: EntryType, content: String, photoData: Data? = nil, caption: String? = nil) {
        self.timestamp = timestamp
        self.type = type
        self.content = content
        self.photoData = photoData
        self.caption = caption
    }
}

enum EntryType: String, Codable {
    case note
    case photo
}
