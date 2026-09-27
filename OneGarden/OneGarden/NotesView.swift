//
//  NotesView.swift
//  OneGarden
//
//  Created by Adam Boyher on 9/2/24.
//

import SwiftUI
import SwiftData

struct NotesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var notes: [Note]
    @State var plant: Plant?
    @State private var isShowingAddNoteViewSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(notes) { note in
                    NoteItemView(note: note, showPlantLabel: true)
                }
            }
            .navigationTitle(plant?.name ?? "All Notes")
            .toolbar {
                Button {
                    isShowingAddNoteViewSheet = true
                } label: {
                    Image(systemName: "plus.app")
                }
            }
            .sheet(isPresented: $isShowingAddNoteViewSheet, content: {
                AddNoteView()
            })
        }
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
    container.mainContext.insert(note1)
    container.mainContext.insert(note2)
    return NotesView()
        .modelContainer(container)
}
