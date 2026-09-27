//
//  Models.swift
//  Blues
//
//  Created by Adam Boyher on 8/12/24.
//

import Foundation

struct Game: Identifiable, Codable {
    let id: Int
    let date: Date
    let homeTeam: String
    let awayTeam: String
    let homeScore: Int
    let awayScore: Int
    let isWinner: Bool?
    let status: String
    let venue: String
    let inning: Int?
    let isTopInning: Bool?
    let balls: Int?
    let strikes: Int?
    let outs: Int?
    let boxscore: Boxscore?
    var detailedLinescore: DetailedLinescore?
}

struct Boxscore: Codable {
    let home: TeamBoxscore
    let away: TeamBoxscore
}

struct TeamBoxscore: Codable {
    let runs: Int
    let hits: Int
    let errors: Int
    let leftOnBase: Int
}

struct Record: Codable {
    let wins: Int
    let losses: Int
    let pct: String
}

struct TeamStanding: Identifiable, Codable {
    let id = UUID()
    let name: String
    let wins: Int
    let losses: Int
    let gamesBack: String
}

// These structures should match the JSON response from the API
struct ScheduleResponse: Codable {
    let dates: [DateSchedule]
}

struct DateSchedule: Codable {
    let games: [GameResponse]
}

struct GameResponse: Codable {
    let gamePk: Int
    let gameDate: String
    let status: GameStatus
    let teams: Teams
    let venue: Venue
    let linescore: Linescore?
}

struct Linescore: Codable {
    let teams: LinescoreTeams
    let currentInning: Int?
    let isTopInning: Bool?
    let balls: Int?
    let strikes: Int?
    let outs: Int?
}

struct LinescoreTeams: Codable {
    let home: LinescoreTeam
    let away: LinescoreTeam
}

struct LinescoreTeam: Codable {
    let runs: Int?
    let hits: Int?
    let errors: Int?
    let leftOnBase: Int?
}

struct GameStatus: Codable {
    let abstractGameState: String
}

struct Teams: Codable {
    let away: TeamInfo
    let home: TeamInfo
}

struct TeamInfo: Codable {
    let score: Int?
    let team: Team
    let isWinner: Bool?
}

struct Team: Codable {
    let id: Int
    let name: String
}

struct Venue: Codable {
    let name: String
}

struct StandingsResponse: Codable {
    let records: [DivisionRecord]
}

struct DivisionRecord: Codable {
    let teamRecords: [TeamRecord]
    let division: Division
}

struct Division: Codable {
    let id: Int
}

struct TeamRecord: Codable {
    let team: Team
    let leagueRecord: Record
    let divisionRank: String
    let wildCardRank: String?
    let gamesBack: String
    let wildCardGamesBack: String?
    let records: Records
}

struct Records: Codable {
    let splitRecords: [SplitRecord]
}

struct SplitRecord: Codable {
    let type: String
    let wins: Int
    let losses: Int
}

struct NewsItem: Identifiable {
    let id: Int
    let title: String
    let description: String
    let pubDate: Date
    let link: String
}

struct LiveFeedResponse: Codable {
    let liveData: LiveData
    let gameData: GameData
}

struct GameData: Codable {
    let teams: Teams
}

struct LiveData: Codable {
    let linescore: DetailedLinescore
}

struct DetailedLinescore: Codable {
    let currentInning: Int
    let currentInningOrdinal: String
    let inningState: String
    let inningHalf: String
    let isTopInning: Bool
    let scheduledInnings: Int
    let innings: [InningDetail]
    let teams: DetailedLinescoreTeams
    let defense: Defense?
    let offense: Offense?
    let balls: Int
    let strikes: Int
    let outs: Int
    var homeTeam: String
    var awayTeam: String
}

struct InningDetail: Codable, Identifiable {
    let num: Int
    let ordinalNum: String
    let home: InningScore
    let away: InningScore
    
    var id: Int { num }
}

struct InningScore: Codable {
    let runs: Int
    let hits: Int
    let errors: Int
    let leftOnBase: Int
}

struct DetailedLinescoreTeams: Codable {
    let home: DetailedTeamScore
    let away: DetailedTeamScore
}

struct DetailedTeamScore: Codable {
    let runs: Int
    let hits: Int
    let errors: Int
    let leftOnBase: Int
}

struct Defense: Codable {
    let pitcher: Player
    let catcher: Player
    let first: Player
    let second: Player
    let third: Player
    let shortstop: Player
    let left: Player
    let center: Player
    let right: Player
}

struct Offense: Codable {
    let batter: Player
    let onDeck: Player
    let inHole: Player
    let pitcher: Player
    let battingOrder: Int
    let team: Team
}

struct Player: Codable {
    let id: Int
    let fullName: String
    let link: String
}
