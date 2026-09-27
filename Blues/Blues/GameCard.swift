//
//  GameCard.swift
//  Blues
//
//  Created by Adam Boyher on 8/12/24.
//

import SwiftUI

struct GameCard: View {
    let game: Game
    
    var body: some View {
        
        NavigationLink(destination: GameView(game: game)) {
            if game.status == "Live" {
                GameInProgressView(game: game)
            } else {
                UpcomingGameView(game: game)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
