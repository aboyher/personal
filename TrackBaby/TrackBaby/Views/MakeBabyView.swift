//
//  MakeBabyView.swift
//  TrackBaby
//
//  Created by Adam Boyher on 6/8/24.
//

import SwiftUI
import SwiftData

struct MakeBabyView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.presentationMode) var presentationMode
    @Bindable var profile: Profile
    @State  var name: String = ""
    @State  var birthDate: Date = Date()
    @State  var gender: Gender = .Boy
    @State  var theme: Theme = .purple
    
    var body: some View {
        VStack {
            TextField("Name", text: $name)
            DatePicker("Birthday", selection: $birthDate, displayedComponents: .date)
            Picker("Gender", selection: $gender) {
                ForEach(Gender.allCases, id: \.self) { option in
                    Text(String(describing: option))
                }
            }
            ThemePickerView(selection: $theme)
            Button(action: {
                logBaby()
            }) {
                Image(systemName: "checkmark") // Example button content
                    .foregroundColor(.white)
                    .padding() // Makes the content area larger, creating a larger tap target
                    .background(Color.blue) // Background color of the button
                    .clipShape(Circle()) // Clips the background to a circle
            }
            .frame(width: 44, height: 44) // Set the frame size of the button
            Spacer()
        }
    }
    
    private func logBaby() {
        let baby = Baby(profile: profile, name: name, gender: gender, theme: theme)
        modelContext.insert(baby)
        profile.selectedBaby = baby
        self.presentationMode.wrappedValue.dismiss()
    }
}
