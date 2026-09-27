//
//  TestView.swift
//  Blues
//
//  Created by Adam Boyher on 8/12/24.
//

import SwiftUI

import SwiftUI

struct TestView: View {
    
    @State private var selectedOption = "Option 1"
        let options = ["Option 1", "Option 2", "Option 3"]
        
        var body: some View {
            NavigationView {
                Text("Content")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            PickerNavigationTitleView(selection: $selectedOption, options: options)
                        }
                    }
            }
        }
}

struct PickerNavigationTitleView: View {
    @Binding var selection: String
    let options: [String]
    @State private var isPresented = false
    
    var body: some View {
        Button(action: {
            isPresented.toggle()
        }) {
            HStack {
                Text(selection)
                    .font(.headline)
                    .fontWeight(.bold)
                Image(systemName: "chevron.down")
                    .font(.caption)
            }
        }
        .foregroundColor(.primary)
        .confirmationDialog("Select Option", isPresented: $isPresented) {
            ForEach(options, id: \.self) { option in
                Button(option) {
                    selection = option
                }
            }
        }
    }
}

#Preview {
    TestView()
}
