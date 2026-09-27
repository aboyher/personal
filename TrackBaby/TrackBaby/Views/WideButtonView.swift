//
//  WideButtonView.swift
//  TrackBaby
//
//  Created by Adam Boyher on 6/8/24.
//

import SwiftUI

struct WideButtonView: View {
    @State var text: String
    var body: some View {
        HStack {
            Spacer() // Pushes the content to fill the width
            Text(text)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Spacer() // Pushes the content to fill the width
        }
        .padding() // Adds padding inside the button
        .background(Color.blue) // Sets the background color of the button
        .cornerRadius(8) // Optional: Adds rounded corners
    }
}

