//
//  Item.swift
//  OneGarden
//
//  Created by Adam Boyher on 9/2/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
