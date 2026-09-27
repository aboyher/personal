import SwiftUI
import SwiftData
import PhotosUI

struct CropDetailView: View {
    @Bindable var crop: Crop
    @State private var isAddingEntry = false
    @State private var newEntryType: EntryType = .note
    @State private var newEntryContent = ""
    @State private var newEntryImage: UIImage?
    @State private var newEntryCaption = ""
    @State private var photoPickerItem: PhotosPickerItem?
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                headerView
                
                ForEach(sortedEntries) { entry in
                    EntryRowView(entry: entry)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(crop.name)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            ToolbarItem(placement: .primaryAction) {
                Button(action: { isAddingEntry = true }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                }
            }
        }
        .sheet(isPresented: $isAddingEntry) {
            AddEntryView(
                entryType: $newEntryType,
                content: $newEntryContent,
                image: $newEntryImage,
                caption: $newEntryCaption,
                photoPickerItem: $photoPickerItem,
                onSave: addEntry
            )
        }
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(crop.name)
                .font(.title)
                .fontWeight(.bold)
            Text("Planted on: \(formattedDate(crop.plantDate))")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("Quantity: \(crop.quantity)")
                .font(.subheadline)
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(Color.green.opacity(0.2))
                .cornerRadius(4)
        }
    }
    
    private var sortedEntries: [Entry] {
        crop.entries.sorted { $0.timestamp > $1.timestamp }
    }
    
    private func addEntry() {
        let newEntry: Entry
        if newEntryType == .photo {
            guard let imageData = newEntryImage?.jpegData(compressionQuality: 0.8) else { return }
            newEntry = Entry(timestamp: Date(), type: .photo, content: "", photoData: imageData, caption: newEntryCaption)
        } else {
            newEntry = Entry(timestamp: Date(), type: .note, content: newEntryContent)
        }
        crop.entries.append(newEntry)
        do {
            try modelContext.save()
        } catch {
            print("Error saving new entry: \(error.localizedDescription)")
        }
        resetNewEntryFields()
    }
    
    private func resetNewEntryFields() {
        newEntryType = .note
        newEntryContent = ""
        newEntryImage = nil
        newEntryCaption = ""
        photoPickerItem = nil
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}

