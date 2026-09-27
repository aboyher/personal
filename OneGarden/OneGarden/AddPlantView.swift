//
//  AddPlantView.swift
//  OneGarden
//
//  Created by Adam Boyher on 9/2/24.
//

import SwiftUI
import SwiftData

struct AddPlantView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var plantName: String = ""
    @State private var themeColor: Color = Color.green
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Plant Details")) {
                    TextField("Plant Name", text: $plantName)
                    
                    ColorPicker("Theme Picker", selection: $themeColor)
                }
            }
            .navigationTitle("Add Plant")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        savePlant()
                    }
                    .disabled(plantName.isEmpty)
                }
            }
        }
    }
    
    private func savePlant() {
        let newPlant = Plant(name: plantName, themeColor: themeColor)
        modelContext.insert(newPlant)
        dismiss()
    }
}

//#Preview {
//    let config = ModelConfiguration(isStoredInMemoryOnly: true)
//    let container = try! ModelContainer(for: Plant.self, configurations: config)
//    let strawberry = Plant(name: "Strawberry", themeColor: Color.red)
//    let blueberry = Plant(name: "Blueberry", themeColor: Color.blue)
//    let note1 = Note(title: "Strawberry note", content: "Content", plant: strawberry)
//    let note2 = Note(title: "Blueberry note", content: "Content", plant: blueberry)
//    container.mainContext.insert(strawberry)
//    container.mainContext.insert(blueberry)
//    container.mainContext.insert(note1)
//    container.mainContext.insert(note2)
//    return AddPlantView()
//        .modelContainer(container)
//}
