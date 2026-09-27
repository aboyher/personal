//
//  CardinalsModels.swift
//  Sports
//
//  Created by Adam Boyher on 8/12/24.
//

import Foundation

struct Schedule: Codable {
    let dates: [ScheduleDate]
    
    struct ScheduleDate: Codable {
        let date: String
        let games: [ScheduleGame]
    }
    
    struct ScheduleGame: Codable {
        let gamePk: Int
        let link: String
        let gameDate: String
        let teams: Teams
        let status: Status
        let decision: Decision?
    }
    
    struct Teams: Codable {
        let away: TeamInfo
        let home: TeamInfo
    }

    struct TeamInfo: Codable {
        let leagueRecord: Record?
        let team: Team
        let score: Int?
        let isWinner: Bool?
        let probablePitcher: Pitcher?
    }

    struct Team: Codable {
        let id: Int
        let name: String
        let link: String
    }

    struct Record: Codable {
        let wins: Int
        let losses: Int
        let pct: String
    }

    struct Pitcher: Codable {
        let fullName: String
    }

    struct Status: Codable {
        let abstractGameState: String
        let codedGameState: String
        let detailedState: String
    }

    struct Decision: Codable {
        let winner: Pitcher
        let loser: Pitcher
        let save: Pitcher?
    }

    struct Venue: Codable {
        let name: String
    }


}




struct LiveFeed: Codable {
    let gameData: GameData
    let liveData: LiveData
    
    struct GameData: Codable {
        let game: Game
        let status: Status
        let teams: Teams
        let venue: Venue
//        let weather: Weather
        let probablePitchers: ProbablePitchers
        let datetime: DateTime
    }
    struct DateTime: Codable {
        let dateTime: String
        let officialDate: String
        let dayNight: String
        let time: String
        let ampm: String
    }
    
    struct Game: Codable {
        let pk: Int
    }
    
    struct Status: Codable {
        let abstractGameState: String
        let detailedState: String
    }
    
    struct Teams: Codable {
        let away: Team
        let home: Team
    }
    
    struct Team: Codable {
        let id: Int
        let name: String
        let link: String
        let abbreviation: String
        let teamName: String
        let shortName: String
        let record: Record
        let clubName: String
    }
    
    struct Record: Codable {
        let gamesPlayed: Int
        let wins: Int
        let losses: Int
        let winningPercentage: String
    }
    
    struct Venue: Codable {
        let id: Int
        let name: String
        let location: VenueLocation
    }
    
    struct VenueLocation: Codable {
        let city: String
        let state: String
        let stateAbbrev: String
    }
    
    struct ProbablePitchers: Codable {
        let away: Player
        let home: Player
    }
    
    struct Player: Codable {
        let id: Int
        let fullName: String
        let link: String
    }
    
    struct LiveData: Codable {
        let plays: Plays
        let linescore: Linescore
        let boxscore: Boxscore
//        let decisions: Decisions?
    }

    // MARK: - Plays
    struct Plays: Codable {
        let allPlays: [Play]?
        let currentPlay: Play?
        let scoringPlays: [Int]?
        let playsByInning: [PlaysByInning]?
    }

    // MARK: - Play
    struct Play: Codable {
        let result: PlayResult
        let about: PlayAbout
        let count: Count
        let matchup: Matchup
        let pitchIndex: [Int]
        let actionIndex: [Int]?
        let runnerIndex: [Int]?
        let playEvents: [PlayEvent]?
    }

    // MARK: - PlayResult
    struct PlayResult: Codable {
        let type: String
        let event: String
        let eventType: String
        let description: String
        let rbi: Int?
        let awayScore: Int
        let homeScore: Int
    }

    // MARK: - PlayAbout
    struct PlayAbout: Codable {
        let atBatIndex: Int
        let halfInning: String
        let isTopInning: Bool
        let inning: Int
        let startTime: String
        let endTime: String?
        let isComplete: Bool
        let isScoringPlay: Bool
        let hasReview: Bool
        let hasOut: Bool
        let captivatingIndex: Int
    }

    // MARK: - Count
    struct Count: Codable {
        let balls: Int
        let strikes: Int
        let outs: Int
    }

    // MARK: - Matchup
    struct Matchup: Codable {
        let batter: Player
        let pitcher: Player
        let postOnFirst: Player?
        let postOnSecond: Player?
        let postOnThird: Player?
    }

    // MARK: - PlayEvent
    struct PlayEvent: Codable {
        let details: PlayEventDetails
        let count: Count
        let index: Int
        let startTime: String
        let endTime: String
        let isPitch: Bool
        let type: String
        let player: Player?
    }

    // MARK: - PlayEventDetails
    struct PlayEventDetails: Codable {
        let description: String?
        let code: String?
        let ballColor: String?
        let trailColor: String?
        let isInPlay: Bool?
        let isStrike: Bool?
        let isBall: Bool?
        let type: PlayEventType
        let hasReview: Bool?
    }

    // MARK: - PlayEventType
    struct PlayEventType: Codable {
        let code: String
        let description: String
    }

    // MARK: - PlaysByInning
    struct PlaysByInning: Codable {
        let startIndex: Int
        let endIndex: Int
        let top: [Int]
        let bottom: [Int]
        let hits: Hits
    }

    // MARK: - Hits
    struct Hits: Codable {
        let away: [Int]
        let home: [Int]
    }

    // MARK: - Linescore
    struct Linescore: Codable {
        let currentInning: Int?
        let currentInningOrdinal: String?
        let inningState: String?
        let inningHalf: String?
        let isTopInning: Bool?
        let scheduledInnings: Int
        let innings: [Inning]?
        let teams: LinescoreTeams
        let defense: Defense
        let offense: Offense
        let balls: Int?
        let strikes: Int?
        let outs: Int?
    }

    // MARK: - Inning
    struct Inning: Codable {
        let num: Int
        let ordinalNum: String
        let home: InningTeam
        let away: InningTeam
    }

    // MARK: - InningTeam
    struct InningTeam: Codable {
        let runs: Int
        let hits: Int
        let errors: Int
        let leftOnBase: Int
    }

    // MARK: - LinescoreTeams
    struct LinescoreTeams: Codable {
        let home: LinescoreTeam
        let away: LinescoreTeam
    }

    // MARK: - LinescoreTeam
    struct LinescoreTeam: Codable {
        let runs: Int?
        let hits: Int?
        let errors: Int?
        let leftOnBase: Int?
    }

    // MARK: - Defense
    struct Defense: Codable {
        let pitcher: Player?
        let catcher: Player?
        let first: Player?
        let second: Player?
        let third: Player?
        let shortstop: Player?
        let left: Player?
        let center: Player?
        let right: Player?
        let batter: Player?
        let onDeck: Player?
        let inHole: Player?
        let battingOrder: Int?
        let team: TeamInfo
    }

    // MARK: - Offense
    struct Offense: Codable {
        let batter: Player?
        let onDeck: Player?
        let inHole: Player?
        let pitcher: Player?
        let battingOrder: Int?
        let team: TeamInfo
    }

    // MARK: - TeamInfo
    struct TeamInfo: Codable {
        let id: Int
        let name: String
        let link: String
    }

    // MARK: - Boxscore
    struct Boxscore: Codable {
        let teams: BoxscoreTeams
//        let info: [Info]
//        let pitchingNotes: [String]?
    }

    // MARK: - BoxscoreTeams
    struct BoxscoreTeams: Codable {
        let away: BoxscoreTeam
        let home: BoxscoreTeam
    }

    // MARK: - BoxscoreTeam
    struct BoxscoreTeam: Codable {
        let team: TeamInfo
        let teamStats: TeamStats
        let players: [String: BoxscorePlayer]
        let batters: [Int]
        let pitchers: [Int]
        let bench: [Int]
        let bullpen: [Int]
        let battingOrder: [Int]?
        let info: [Info]
        let note: [String]?
    }

    // MARK: - TeamStats
    struct TeamStats: Codable {
        let batting: BattingStats
        let pitching: PitchingStats
        let fielding: FieldingStats
    }

    // MARK: - BattingStats
    struct BattingStats: Codable {
        let flyOuts: Int?
        let groundOuts: Int?
        let runs: Int?
        let doubles: Int?
        let triples: Int?
        let homeRuns: Int?
        let strikeOuts: Int?
        let baseOnBalls: Int?
        let intentionalWalks: Int?
        let hits: Int?
        let hitByPitch: Int?
        let avg: String?
        let atBats: Int?
        let obp: String?
        let slg: String?
        let ops: String?
        let caughtStealing: Int?
        let stolenBases: Int?
        let stolenBasePercentage: String?
        let groundIntoDoublePlay: Int?
        let groundIntoTriplePlay: Int?
        let plateAppearances: Int?
        let totalBases: Int?
        let rbi: Int?
        let leftOnBase: Int?
        let sacBunts: Int?
        let sacFlies: Int?
        let babip: String?
        let catchersInterference: Int?
        let pickoffs: Int?
    }

    // MARK: - PitchingStats
    struct PitchingStats: Codable {
        let groundOuts: Int?
        let airOuts: Int?
        let runs: Int?
        let doubles: Int?
        let triples: Int?
        let homeRuns: Int?
        let strikeOuts: Int?
        let baseOnBalls: Int?
        let intentionalWalks: Int?
        let hits: Int?
        let hitByPitch: Int?
        let atBats: Int?
        let obp: String?
        let caughtStealing: Int?
        let stolenBases: Int?
        let stolenBasePercentage: String?
        let numberOfPitches: Int?
        let era: String?
        let inningsPitched: String?
        let saveOpportunities: Int?
        let earnedRuns: Int?
        let whip: String?
        let battersFaced: Int?
        let outs: Int?
        let completeGames: Int?
        let shutouts: Int?
        let pitchesThrown: Int?
        let balls: Int?
        let strikes: Int?
        let strikePercentage: String?
        let hitBatsmen: Int?
        let balks: Int?
        let wildPitches: Int?
        let pickoffs: Int?
        let groundOutsToAirouts: String?
        let rbi: Int?
        let winPercentage: String?
        let gamesPlayed: Int?
        let gamesStarted: Int?
        let walksPer9Inn: String?
        let hitsPer9Inn: String?
        let runsScoredPer9: String?
        let homeRunsPer9: String?
        let inheritedRunners: Int?
        let inheritedRunnersScored: Int?
        let catchersInterference: Int?
        let sacBunts: Int?
        let sacFlies: Int?
    }

    // MARK: - FieldingStats
    struct FieldingStats: Codable {
        let assists: Int?
        let putOuts: Int?
        let errors: Int?
        let chances: Int?
        let fielding: String?
        let caughtStealing: Int?
        let passedBall: Int?
        let stolenBases: Int?
        let stolenBasePercentage: String?
        let pickoffs: Int?
    }

    // MARK: - BoxscorePlayer
    struct BoxscorePlayer: Codable {
        let person: Player?
        let jerseyNumber: String?
        let position: Position?
        let stats: PlayerStats?
        let status: PlayerStatus?
        let parentTeamId: Int?
        let battingOrder: Int?
        let seasonStats: SeasonStats?
        let gameStatus: GameStatus?
    }

    // MARK: - PlayerStats
    struct PlayerStats: Codable {
        let batting: BattingStats?
        let pitching: PitchingStats?
        let fielding: FieldingStats?
    }

    // MARK: - PlayerStatus
    struct PlayerStatus: Codable {
        let code: String?
        let description: String?
    }

    // MARK: - SeasonStats
    struct SeasonStats: Codable {
        let batting: BattingStats?
        let pitching: PitchingStats?
        let fielding: FieldingStats?
    }

    // MARK: - GameStatus
    struct GameStatus: Codable {
        let isCurrentBatter: Bool?
        let isCurrentPitcher: Bool?
        let isOnBench: Bool?
        let isSubstitute: Bool?
    }

    // MARK: - Official
    struct Official: Codable {
        let official: Player?
        let officialType: String?
    }

    // MARK: - Info
    struct Info: Codable {
        let label: String?
        let value: String?
    }

    // MARK: - Decisions
    struct Decisions: Codable {
        let winner: Player?
        let loser: Player?
        let save: Player?
    }
    
    struct Position: Codable {
        let code: String?
        let name: String?
        let type: String?
        let abbreviation: String?
    }
}

// Models to decode the stats API response
struct StatsResponse: Codable {
    let stats: [PlayerStat]
    
    struct PlayerStat: Codable {
        let player: Player
        let stat: PlayerStats.StatDetail
    }
    
    struct Player: Codable {
        let id: Int
        let fullName: String
    }
}

// Represents a player's complete stats, including hitting and pitching
struct PlayerStats: Codable, Identifiable {
    let id: Int
    let fullName: String
    var stats: Stats
    
    struct Stats: Codable {
        var hitting: StatDetail?
        var pitching: StatDetail?
    }
    
    struct StatDetail: Codable {
        let gamesPlayed: Int
        let atBats: Int?
        let hits: Int?
        let homeRuns: Int?
        let runsBattedIn: Int?
        let earnedRunAverage: Double?
        let strikeOuts: Int?
        let wins: Int?
        let losses: Int?
        
        // Add more fields as needed
    }
}

// Represents the entire roster of players
struct Roster: Codable {
    var players: [PlayerStats]
}
