//
//  AddCropView.swift
//  Blumen
//
//  Created by Adam Boyher on 7/22/24.
//

import SwiftUI
import SwiftData

struct AddCropView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var cropName: String = ""
    @State private var plantDate: Date = Date()
    @State private var quantity: Int = 0
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Crop")) {
                    TextField("Crop Name", text: $cropName)
                    DatePicker("Plant Date", selection: $plantDate, displayedComponents: [.date])

                    LabeledContent {
                        TextField("Quantity", value: $quantity, format: .number)
                    } label: {
                        Text("Quantity: ")
                    }
                }
            }
            .navigationTitle("Add New Crop")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    saveCrop()
                }
                .disabled(cropName.isEmpty)
            )
        }
    }
    
    private func saveCrop() {
        let newCrop = Crop(name: cropName, plantDate: Date(), quantity: quantity)
        modelContext.insert(newCrop)
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Error saving crop: \(error.localizedDescription)")
        }
    }
}

#Preview {
    AddCropView()
        .modelContainer(for: Crop.self, inMemory: true)
}
