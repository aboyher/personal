
import SwiftUI
import PhotosUI

struct AddEntryView: View {
    @Binding var entryType: EntryType
    @Binding var content: String
    @Binding var image: UIImage?
    @Binding var caption: String
    @Binding var photoPickerItem: PhotosPickerItem?
    let onSave: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Picker("Entry Type", selection: $entryType) {
                    Text("Note").tag(EntryType.note)
                    Text("Photo").tag(EntryType.photo)
                }
                .pickerStyle(SegmentedPickerStyle())
                
                if entryType == .note {
                    TextEditor(text: $content)
                        .frame(height: 150)
                        .border(Color.secondary.opacity(0.2), width: 1)
                } else {
                    PhotosPicker(selection: $photoPickerItem, matching: .images) {
                        if let image = image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                        } else {
                            Text("Select a photo")
                                .frame(height: 200)
                                .frame(maxWidth: .infinity)
                                .background(Color.secondary.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                    .onChange(of: photoPickerItem) { _ in
                        Task {
                            if let data = try? await photoPickerItem?.loadTransferable(type: Data.self) {
                                if let uiImage = UIImage(data: data) {
                                    image = uiImage
                                }
                            }
                        }
                    }
                    
                    TextField("Add a caption...", text: $caption)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("New Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Post") {
                        onSave()
                        dismiss()
                    }
                    .disabled(entryType == .note ? content.isEmpty : image == nil)
                }
            }
        }
    }
}

