//
//  CardinalsLastTenView.swift
//  Sports
//
//  Created by Adam Boyher on 8/14/24.
//

import SwiftUI

struct CardinalsLastTenView: View {
    @ObservedObject var viewModel: CardinalsScheduleViewModel
    
    var body: some View {
            List {
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.error {
                    Text("Error: \(error.localizedDescription)")
                } else {
                    ForEach(viewModel.lastTenGames, id: \.gamePk) {game in
                        LastTenGameRow(game: game)
                    }
                }
                
        }
            .scrollContentBackground(.hidden)
            .background(.white)
            .clipped()
    }
}


struct LastTenGameRow: View {
    let game: Schedule.ScheduleGame
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(formattedDate(game.gameDate))
                    .font(.caption)
                Spacer()
                Text(game.status.detailedState)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text(game.teams.away.team.name)
                    Text(game.teams.home.team.name)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("\(game.teams.away.score ?? 0)")
                        .foregroundColor(cardinalsScoreColor(for: .away))
                    Text("\(game.teams.home.score ?? 0)")
                        .foregroundColor(cardinalsScoreColor(for: .home))
                }
            }
            
            if let decision = game.decision {
                VStack(alignment: .leading) {
                    Text("W: \(decision.winner.fullName)")
                    Text("L: \(decision.loser.fullName)")
                    if let save = decision.save {
                        Text("S: \(save.fullName)")
                    }
                }
                .font(.caption)
            }
        }
        .padding(.vertical, 8)
    }
    
    private func cardinalsScoreColor(for team: Team) -> Color {
        let cardinalsId = 138
        let isCardinalsTeam = (team == .home && game.teams.home.team.id == cardinalsId) ||
                              (team == .away && game.teams.away.team.id == cardinalsId)
        
        if isCardinalsTeam {
            let cardinalsScore = team == .home ? game.teams.home.score : game.teams.away.score
            let opponentScore = team == .home ? game.teams.away.score : game.teams.home.score
            
            if let cardinalsScore = cardinalsScore, let opponentScore = opponentScore {
                return cardinalsScore > opponentScore ? .green : .red
            }
        }
        return .primary
    }
    
    private func formattedDate(_ dateString: String) -> String {
        let inputFormatter = ISO8601DateFormatter()
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMM d, yyyy"
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        } else {
            return dateString
        }
    }
    
    private enum Team {
        case home, away
    }
}
