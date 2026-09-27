//
//  PlantsView.swift
//  OneGarden
//
//  Created by Adam Boyher on 9/2/24.
//

import SwiftUI
import SwiftData

struct PlantsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var isShowingAddPlantViewSheet = false
    @Query private var plants: [Plant]
    
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                LazyVGrid(columns: columns, spacing: 16){
                    ForEach(plants){ plant in
                        NavigationLink {
                            PlantView(plant: plant)
                        } label: {
                            PlantItem(plant: plant)
                        }
                    }
                }
            }
            .navigationTitle("Plants")
            .toolbar {
                Button {
                    isShowingAddPlantViewSheet = true
                } label: {
                    Image(systemName: "plus.app")
                }
            }
            .sheet(isPresented: $isShowingAddPlantViewSheet, content: {
                AddPlantView()
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
//    container.mainContext.insert(note1)
//    container.mainContext.insert(note2)
    return PlantsView()
        .modelContainer(container)
}
