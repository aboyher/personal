//
//  NoteItemView.swift
//  OneGarden
//
//  Created by Adam Boyher on 9/2/24.
//

import SwiftUI
import SwiftData

struct NoteItemView: View {
    @State var note: Note
    @State var showPlantLabel = false
    
    var body: some View {
        VStack(alignment: .leading) {
            if showPlantLabel {
                Text(note.plant?.name ?? "Unfiled")
                    .font(.caption2)
                    .foregroundColor(Color(hex: note.plant?.themeColor ?? "#808080"))
            }
            Text(note.title)
                .font(.title)
            Text(note.content)
                .font(.body)
        }
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
//    return NoteItemView(note: note1, showPlantLabel: true).modelContainer(container)
//}
