//
//  GoatApp.swift
//  Goat
//
//  Created by Adam Boyher on 9/30/24.
//

import SwiftUI

@main
struct GoatApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
