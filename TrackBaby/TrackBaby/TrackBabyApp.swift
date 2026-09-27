//
//  TrackBabyApp.swift
//  TrackBaby
//
//  Created by Adam Boyher on 6/7/24.
//

import SwiftUI
import SwiftData

@main
struct TrackBabyApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Profile.self)
    }
}
