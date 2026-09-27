//
//  ContentView.swift
//  Blumen
//
//  Created by Adam Boyher on 7/22/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State var selectedTab = "Crops"

    var body: some View {
        TabView(selection: $selectedTab) {
                    CropView()
                    .tabItem {
                        Label("Crops", systemImage: "leaf")
                    }
                    .tag("Crops")
                }
    }
}

#Preview {
    // Create a ModelContainer for the preview
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Crop.self, configurations: config)
    
    // Add a sample crop
    let sampleCrop = Crop(name: "Tomatoes", plantDate: Date(), quantity: 10)
    container.mainContext.insert(sampleCrop)
    
    // Return the ContentView with the prepared ModelContainer
    return ContentView()
        .modelContainer(container)
}
