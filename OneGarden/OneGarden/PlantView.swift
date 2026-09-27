//
//  PlantView.swift
//  OneGarden
//
//  Created by Adam Boyher on 9/2/24.
//

import SwiftUI
import SwiftData

struct PlantView: View {
    @Environment(\.modelContext) private var modelContext
    @State var plant: Plant
    @State private var isShowingAddNoteViewSheet = false
    @Query var notes: [Note]
    
    init(plant: Plant){
        self.plant = plant
        let id = plant.persistentModelID
        let predicate = #Predicate<Note>{note in
            note.plant?.persistentModelID == id
        }
        _notes = Query(filter: predicate)
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(notes) { note in
                    NoteItemView(note: note)
                }
            }
        }
        .navigationTitle(plant.name)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            Button {
                isShowingAddNoteViewSheet = true
            } label: {
                Image(systemName: "plus.app")
            }
        }
        .sheet(isPresented: $isShowingAddNoteViewSheet, content: {
            AddNoteView(selectedPlant: plant)
        })
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Plant.self, configurations: config)
    let strawberry = Plant(name: "Strawberry", themeColor: Color.red)
    let blueberry = Plant(name: "Blueberry", themeColor: Color.blue)
    let note1 = Note(title: "Strawberry note", content: "Content", plant: strawberry)
    let note2 = Note(title: "Blueberry note", content: "Content", plant: blueberry)
    container.mainContext.insert(strawberry)
    container.mainContext.insert(blueberry)
//    container.mainContext.insert(note1)
//    container.mainContext.insert(note2)
    return PlantView(plant: strawberry).modelContainer(container)
}
