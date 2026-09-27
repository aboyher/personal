//
//  GameInProgressView.swift
//  Blues
//
//  Created by Adam Boyher on 8/12/24.
//

import SwiftUI

struct GameInProgressView: View {
    let game: Game
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("LIVE")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(4)
                
                Spacer()
                
                Text(formattedInning)
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            
            HStack(alignment: .center, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    
                    TeamScoreRow(teamName: game.awayTeam, score: game.awayScore, isWinning: game.awayScore > game.homeScore)
                    TeamScoreRow(teamName: game.homeTeam, score: game.homeScore, isWinning: game.homeScore > game.awayScore)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("B: \(game.balls ?? 0)")
                    Text("S: \(game.strikes ?? 0)")
                    Text("O: \(game.outs ?? 0)")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
            
            if let boxscore = game.boxscore {
                Divider()
                
                VStack(spacing: 8) {
                    BoxscoreRow(teamName: game.awayTeam, boxscore: boxscore.away)
                    BoxscoreRow(teamName: game.homeTeam, boxscore: boxscore.home)
                }
            }
            
            Text(game.venue)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(10)
    }
    
    private var formattedInning: String {
        guard let inning = game.inning, let isTopInning = game.isTopInning else {
            return "In Progress"
        }
        let inningHalf = isTopInning ? "Top" : "Bottom"
        return "\(inningHalf) \(inning)\(getInningOrdinal(inning))"
    }
    
    private func getInningOrdinal(_ inning: Int) -> String {
        switch inning {
        case 1: return "st"
        case 2: return "nd"
        case 3: return "rd"
        default: return "th"
        }
    }
}

struct BoxscoreRow: View {
    let teamName: String
    let boxscore: TeamBoxscore
    
    var body: some View {
        HStack {
            Text(teamName)
                .font(.caption)
                .frame(width: 80, alignment: .leading)
            
            Spacer()
            
            HStack(spacing: 20) {
                Text("R: \(boxscore.runs)")
                Text("H: \(boxscore.hits)")
                Text("E: \(boxscore.errors)")
                Text("LOB: \(boxscore.leftOnBase)")
            }
            .font(.caption)
        }
    }
}

struct GameInProgressView_Previews: PreviewProvider {
    static var previews: some View {
        GameInProgressView(game: Game(
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
                outs: 1
            )
        ))
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
