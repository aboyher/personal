//
//  ContentView.swift
//  OneGarden
//
//  Created by Adam Boyher on 9/2/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selectedTab = "plants"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            PlantsView().tabItem { Image(systemName: "book.pages")}.tag("plants")
            NotesView().tabItem { Image(systemName: "note.text")}.tag("notes")
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Plant.self, configurations: config)
    let strawberry = Plant(name: "Strawberry", themeColor: Color.red)
    let blueberry = Plant(name: "Blueberry", themeColor: Color.blue)
    let grapes = Plant(name: "Grapes", themeColor: Color.purple)
    let pepper = Plant(name: "Pepper", themeColor: Color.green)
    let carrots = Plant(name: "Carrot", themeColor: Color.orange)
    let lemon = Plant(name: "Lemon", themeColor: Color.yellow)
    let note1 = Note(title: "Strawberry note", content: "Content", plant: strawberry)
    let note2 = Note(title: "Blueberry note", content: "Content", plant: blueberry)
    container.mainContext.insert(strawberry)
    container.mainContext.insert(blueberry)
    container.mainContext.insert(grapes)
    container.mainContext.insert(carrots)
    container.mainContext.insert(lemon)
    container.mainContext.insert(pepper)
    
//    container.mainContext.insert(note1)
//    container.mainContext.insert(note2)
    return ContentView()
        .modelContainer(container)
}
