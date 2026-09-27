//
//  AddNoteView.swift
//  OneGarden
//
//  Created by Adam Boyher on 9/2/24.
//

import SwiftUI
import SwiftData

struct AddNoteView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var plants: [Plant]
    
    @State private var title: String = ""
    @State private var content: String = ""
    @State var selectedPlant: Plant?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Note Details")) {
                    TextField("Title", text: $title)
                    TextEditor(text: $content)
                        .frame(minHeight: 100)
                }
                
                Section(header: Text("Plant")) {
                    Picker("Select Plant", selection: $selectedPlant) {
                        Text("Unfiled").tag(Plant?.none)
                        ForEach(plants){ plant in
                            Text(plant.name).tag(Plant?.some(plant))
                        }
                    }
                }
            }
            .navigationTitle("Add Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveNote()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func saveNote() {
        let newNote = Note(title: title, content: content, plant: selectedPlant)
        modelContext.insert(newNote)
        dismiss()
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
    return AddNoteView().modelContainer(container)
}
