//
//  PlantItem.swift
//  OneGarden
//
//  Created by Adam Boyher on 9/2/24.
//

import SwiftUI
import SwiftData

struct PlantItem: View {
    @State var plant: Plant
    var elevation: CGFloat = 4 // Shadow depth

        var body: some View {
            VStack(alignment: .leading) {
                // Image at the top of the card
                Image(systemName: "leaf")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 150)
                    .clipped()
                    .foregroundColor(Color(hex: plant.themeColor).readableTextColor())
                
                // Title and Description
                VStack(alignment: .leading, spacing: 8) {
                    Text(plant.name)
                        .font(.headline)
                        .foregroundColor(Color(hex: plant.themeColor).readableTextColor())
//                    Text(plant.variety)
//                        .font(.body)
//                        .foregroundColor(Color(hex: plant.themeColor).readableTextColor())
                }
                .padding()
            }
            .background(Color(hex: plant.themeColor))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.2), radius: elevation, x: 0, y: elevation)
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Plant.self, configurations: config)
    let strawberry = Plant(name: "Strawberry", themeColor: Color.red)
    return PlantItem(plant: strawberry)
        .modelContainer(container)
}
