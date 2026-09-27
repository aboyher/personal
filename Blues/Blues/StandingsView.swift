//
//  StandingsView.swift
//  Blues
//
//  Created by Adam Boyher on 8/12/24.
//

import SwiftUI

struct StandingsView: View {
    @ObservedObject var viewModel: CardinalsViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                RecordCards(seasonRecord: viewModel.seasonRecord, lastTenRecord: viewModel.lastTenRecord)
                
                StandingsCard(standings: viewModel.divisionStandings, playoffStatus: viewModel.playoffStatus)
                
                LastGamesSection(games: viewModel.pastGames)
            }
            .padding()
        }
        .navigationTitle("Standings")
    }
}

struct StandingsCard: View {
    let standings: [TeamStanding]
    let playoffStatus: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("NL Central Standings")
                .font(.headline)
            
            ForEach(standings) { team in
                HStack {
                    Text(team.name)
                        .font(.subheadline)
                    Spacer()
                    Text("\(team.wins)-\(team.losses)")
                        .font(.subheadline)
                    Text(team.gamesBack)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(width: 30, alignment: .trailing)
                }
            }
            
            Divider()
            
            Text(playoffStatus)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(10)
    }
}

struct LastGamesSection: View {
    let games: [Game]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Last Games")
                .font(.headline)
            
            ForEach(games) { game in
                GameRow(game: game)
            }
        }
    }
}


struct RecordCards: View {
    let seasonRecord: Record?
    let lastTenRecord: Record?
    
    var body: some View {
        HStack(spacing: 15) {
            RecordCard(title: "Season", record: seasonRecord)
            RecordCard(title: "Last 10", record: lastTenRecord)
        }
    }
}

struct RecordCard: View {
    let title: String
    let record: Record?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(title)
                if title == "Season" && record?.pct != nil {
                    Text("(\(record!.pct))")
                        .foregroundColor(.secondary)
                }
            }
            .font(.headline)
            
            if let record = record {
                Text("\(record.wins)-\(record.losses)")
                    .font(.title)
                    .fontWeight(.bold)
            } else {
                Text("--")
                    .font(.title)
                    .fontWeight(.bold)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(10)
    }
}

struct GameRow: View {
    let game: Game
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(game.homeTeam == "Cardinals" ? game.awayTeam : game.homeTeam)
                    .font(.headline)
                Text(formattedDate(game.date))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if game.status == "Final" {
                VStack(alignment: .trailing) {
                    Text("\(game.awayScore) - \(game.homeScore)")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    if let isWinner = game.isWinner {
                        Text(isWinner ? "WIN" : "LOSS")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(isWinner ? Color.green : Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                    }
                }
            } else {
                Text(game.status)
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(10)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

