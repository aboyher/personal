//
//  LiveGameView.swift
//  Blues
//
//  Created by Adam Boyher on 8/14/24.
//

import SwiftUI

struct GameView: View {
    let game: Game
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(game.homeTeam == "Cardinals" ? game.awayTeam : game.homeTeam)
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Text(formatDate(game.date))
                    .font(.headline)
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text(game.awayTeam)
                        .font(.headline)
                    Text("\(game.awayScore)")
                        .font(.title)
                        .fontWeight(.bold)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(game.homeTeam)
                        .font(.headline)
                    Text("\(game.homeScore)")
                        .font(.title)
                        .fontWeight(.bold)
                }
            }
            
            Text(game.venue)
                .font(.subheadline)
            
            if game.status == "In Progress" {
                GameProgressView(game: game)
            } else if game.status == "Preview" {
                Text("Game starts at \(formatTime(game.date))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            if let detailedLinescore = game.detailedLinescore {
                LinescoreView(linescore: detailedLinescore)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 5)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: date)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}

struct GameProgressView: View {
    let game: Game
    
    var body: some View {
        HStack {
            Text("\(game.isTopInning ?? true ? "Top" : "Bottom") \(game.inning ?? 0)")
            Spacer()
            Text("B: \(game.balls ?? 0) S: \(game.strikes ?? 0) O: \(game.outs ?? 0)")
        }
        .font(.subheadline)
        .foregroundColor(.secondary)
    }
}

struct LinescoreView: View {
    let linescore: DetailedLinescore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Linescore")
                .font(.headline)
            
            HStack {
                Text("Team")
                    .frame(width: 80, alignment: .leading)
                ForEach(linescore.innings) { inning in
                    Text("\(inning.num)")
                        .frame(width: 30)
                }
                Text("R")
                    .frame(width: 30)
                Text("H")
                    .frame(width: 30)
                Text("E")
                    .frame(width: 30)
            }
            .font(.caption)
            
            LinescoreTeamRow(teamName: linescore.awayTeam, innings: linescore.innings.map { $0.away }, totals: linescore.teams.away)
            LinescoreTeamRow(teamName: linescore.homeTeam, innings: linescore.innings.map { $0.home }, totals: linescore.teams.home)
        }
    }
}

struct LinescoreTeamRow: View {
    let teamName: String
    let innings: [InningScore]
    let totals: DetailedTeamScore
    
    var body: some View {
        HStack {
            Text(teamName)
                .frame(width: 80, alignment: .leading)
            ForEach(innings, id: \.runs) { inning in
                Text("\(inning.runs)")
                    .frame(width: 30)
            }
            Text("\(totals.runs)")
                .frame(width: 30)
            Text("\(totals.hits)")
                .frame(width: 30)
            Text("\(totals.errors)")
                .frame(width: 30)
        }
        .font(.caption)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(game: Game(
            id: 1,
            date: Date(),
            homeTeam: "Cardinals",
            awayTeam: "Cubs",
            homeScore: 3,
            awayScore: 2,
            isWinner: nil,
            status: "In Progress",
            venue: "Busch Stadium",
            inning: 5,
            isTopInning: true,
            balls: 2,
            strikes: 1,
            outs: 1,
            boxscore: nil,
            detailedLinescore: DetailedLinescore(
                currentInning: 5,
                currentInningOrdinal: "5th",
                inningState: "Top",
                inningHalf: "Top",
                isTopInning: true,
                scheduledInnings: 9,
                innings: [
                    InningDetail(num: 1, ordinalNum: "1st", home: InningScore(runs: 1, hits: 2, errors: 0, leftOnBase: 1), away: InningScore(runs: 0, hits: 1, errors: 0, leftOnBase: 1)),
                    InningDetail(num: 2, ordinalNum: "2nd", home: InningScore(runs: 0, hits: 1, errors: 0, leftOnBase: 1), away: InningScore(runs: 2, hits: 2, errors: 0, leftOnBase: 0)),
                    InningDetail(num: 3, ordinalNum: "3rd", home: InningScore(runs: 2, hits: 2, errors: 0, leftOnBase: 0), away: InningScore(runs: 0, hits: 0, errors: 1, leftOnBase: 0)),
                    InningDetail(num: 4, ordinalNum: "4th", home: InningScore(runs: 0, hits: 0, errors: 0, leftOnBase: 0), away: InningScore(runs: 0, hits: 1, errors: 0, leftOnBase: 1)),
                    InningDetail(num: 5, ordinalNum: "5th", home: InningScore(runs: 0, hits: 0, errors: 0, leftOnBase: 0), away: InningScore(runs: 0, hits: 0, errors: 0, leftOnBase: 0))
                ],
                teams: DetailedLinescoreTeams(
                    home: DetailedTeamScore(runs: 3, hits: 5, errors: 0, leftOnBase: 2),
                    away: DetailedTeamScore(runs: 2, hits: 4, errors: 1, leftOnBase: 2)
                ),
                defense: nil,
                offense: nil,
                balls: 2,
                strikes: 1,
                outs: 1,
                homeTeam: "Cardinals",
                awayTeam: "Cubs"
            )
        ))
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
