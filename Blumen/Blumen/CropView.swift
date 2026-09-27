import SwiftUI
import SwiftData

struct CropView: View {
    @Query private var crops: [Crop]
    @State private var isShowingAddCropSheet = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                    ForEach(crops) { crop in
                        NavigationLink(destination: CropDetailView(crop: crop)) {
                            CropCard(crop: crop)
                        }
                    }
                }
                .padding(16)
            }
            .navigationTitle("Crops")
            .toolbar {
                ToolbarItem {
                    Button(action: { isShowingAddCropSheet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingAddCropSheet, content: {
                AddCropView()
            })
        }
    }
}

struct CropCard: View {
    let crop: Crop
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(crop.name)
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack {
                Image(systemName: "calendar")
                Text(crop.plantDate, style: .date)
                    .font(.subheadline)
            }
            .foregroundColor(.secondary)
            
            HStack {
                Image(systemName: "number")
                Text("Quantity: \(crop.quantity)")
                    .font(.subheadline)
            }
            .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    // Create a ModelContainer for the preview
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Crop.self, configurations: config)
    
    // Add sample crops
    let sampleCrop1 = Crop(name: "Tomatoes", plantDate: Date(), quantity: 10)
    let sampleCrop2 = Crop(name: "Strawberries", plantDate: Date().addingTimeInterval(-86400 * 7), quantity: 20)
    let sampleCrop3 = Crop(name: "Carrots", plantDate: Date().addingTimeInterval(-86400 * 14), quantity: 30)
    container.mainContext.insert(sampleCrop1)
    container.mainContext.insert(sampleCrop2)
    container.mainContext.insert(sampleCrop3)
    
    // Return the CropView with the prepared ModelContainer
    return CropView()
        .modelContainer(container)
}
