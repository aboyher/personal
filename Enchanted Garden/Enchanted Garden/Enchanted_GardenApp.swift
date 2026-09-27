import SwiftUI
import SwiftData

@main
struct Enchanted_Garden: App {
    var body: some Scene {
        WindowGroup {
            EnchantedContainerView {
                ContentView()
            }
        }
        .modelContainer(for: Plant.self)
    }
}

struct EnchantedContainerView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            EnchantedTheme.background.ignoresSafeArea()
            content
        }
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var plants: [Plant]
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Enchanted Garden")
                    .font(.largeTitle)
                    .foregroundColor(EnchantedTheme.deepForestGreen)
                    .padding()
                
                List {
                    NavigationLink(destination: AddPlantView()) {
                        Label("Add New Plant", systemImage: "wand.and.stars")
                    }
                    NavigationLink(destination: GardenView()) {
                        Label("View Garden", systemImage: "leaf")
                    }
                    NavigationLink(destination: RemindersView()) {
                        Label("Reminders", systemImage: "bell.badge")
                    }
                    NavigationLink(destination: TipsAndTricksView()) {
                        Label("Tips & Tricks", systemImage: "book.closed")
                    }
                    NavigationLink(destination: CommunityView()) {
                        Label("Community", systemImage: "person.3")
                    }
                }
                .listStyle(PlainListStyle())
                .parchmentStyle()
                .padding()
            }
        }
        .accentColor(EnchantedTheme.deepForestGreen)
    }
}

struct AddPlantView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var species = ""
    @State private var plantingDate = Date()
    @State private var location = ""
    @State private var notes = ""
    
    var body: some View {
        Form {
            TextField("Plant Name", text: $name)
            TextField("Species", text: $species)
            DatePicker("Planting Date", selection: $plantingDate, displayedComponents: .date)
            TextField("Location", text: $location)
            TextField("Notes", text: $notes)
            
            Button("Save Plant") {
                let newPlant = Plant(name: name, species: species, plantingDate: plantingDate, location: location, notes: notes)
                modelContext.insert(newPlant)
                dismiss()
            }
            .padding()
            .background(EnchantedTheme.richPurple)
//            .foregroundColor(EnchantedTheme.paleGold)
            .cornerRadius(10)
        }
        .navigationTitle("Add New Plant")
        .foregroundColor(EnchantedTheme.darkPurple)
//        .parchmentBackgroundStyle()
        .padding()
    }
}

struct GardenView: View {
    @Query private var plants: [Plant]
    
    var body: some View {
        List(plants) { plant in
            VStack(alignment: .leading) {
                Text(plant.name)
                    .font(.headline)
                    .foregroundColor(EnchantedTheme.darkPurple)
                Text(plant.species)
                    .font(.subheadline)
                    .foregroundColor(EnchantedTheme.richPurple)
            }
        }
        .navigationTitle("Your Garden")
        .listStyle(PlainListStyle())
        .parchmentStyle()
        .padding()
    }
}

struct RemindersView: View {
    var body: some View {
        Text("Reminders coming soon!")
            .navigationTitle("Reminders")
            .foregroundColor(EnchantedTheme.darkPurple)
//            .parchmentBackgroundStyle()
            .padding()
    }
}

struct TipsAndTricksView: View {
    var body: some View {
        Text("Tips and Tricks coming soon!")
            .navigationTitle("Tips & Tricks")
            .foregroundColor(EnchantedTheme.darkPurple)
//            .parchmentBackgroundStyle()
            .padding()
    }
}

struct CommunityView: View {
    var body: some View {
        Text("Community features coming soon!")
            .navigationTitle("Community")
            .foregroundColor(EnchantedTheme.darkPurple)
//            .parchmentBackgroundStyle()
            .padding()
    }
}


#Preview {
    ContentView()
}
