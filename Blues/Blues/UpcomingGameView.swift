//
//  UpcomingGameView.swift
//  Blues
//
//  Created by Adam Boyher on 8/12/24.
//

import SwiftUI

struct UpcomingGameView: View {
    let game: Game
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(game.status)
                .font(.headline)
                .foregroundColor(.blue)
            
            HStack {
                Text(game.awayTeam)
                Spacer()
                Text("@")
                Spacer()
                Text(game.homeTeam)
            }
            .font(.title3)
            
            Text(game.venue)
            
            Text(formattedDate(game.date))
                .font(.subheadline)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 5)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter.string(from: date)
    }
}
