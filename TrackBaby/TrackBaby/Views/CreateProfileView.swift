//
//  CreateProfileView.swift
//  TrackBaby
//
//  Created by Adam Boyher on 6/8/24.
//

import SwiftUI
import SwiftData

struct CreateProfileView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var parentType: ParentType = .Dad
    @State private var age: Int = 0
    @Query private var profiles: [Profile]
    
    var body: some View {
        Form {
            TextField("Name", text: $name)
            Picker("Age: \(age)", selection: $age) {
                ForEach(0...100, id: \.self) {i in
                    Text("\(i)").tag(i)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(height: 50)
            Picker("Dad or Mom?" ,selection: $parentType) {
                Text(ParentType.Dad.rawValue).tag(ParentType.Dad)
                Text(ParentType.Mom.rawValue).tag(ParentType.Mom)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Button("Save") {
                saveProfile()
            }
        }
    }
    
    private func saveProfile() {
        let newProfile = Profile(name: name, parentType: parentType, age: age)
        modelContext.insert(newProfile)
        dismiss()
    }
}

#Preview {
    CreateProfileView()
        .modelContainer(for: Profile.self)
}
