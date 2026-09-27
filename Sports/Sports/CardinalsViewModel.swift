//
//  CardinalsViewModel.swift
//  Sports
//
//  Created by Adam Boyher on 8/12/24.
//

import Foundation
import FeedKit
import Combine

class CardinalsScheduleViewModel: ObservableObject {
    @Published var schedule: Schedule?
    @Published var lastTenGames: [Schedule.ScheduleGame] = []
    @Published var todaysGame: Schedule.ScheduleGame?
    @Published var nextGame: Schedule.ScheduleGame?
    @Published var isLoading = false
    @Published var error: Error?
    
    private var cancellables = Set<AnyCancellable>()
    private let baseUrlString = "https://statsapi.mlb.com"
    private let teamId = 138
    private let season = 2024
    
    func fetchSchedule() {
        isLoading = true
        error = nil
        
        let urlString = "\(baseUrlString)/api/v1/schedule?teamId=\(teamId)&sportId=1&season=\(season)&gameType=R&hydrate=probablePitcher,decisions"
        guard let url = URL(string: urlString) else {
            error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            isLoading = false
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Schedule.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error
                }
            } receiveValue: { [weak self] schedule in
                self?.schedule = schedule
                self?.findLastTenGames()
                self?.findTodaysGame()
                self?.findNextGame()
            }
            .store(in: &cancellables)
    }
    
    func getGamesForMonth(_ month: Int) -> [Schedule.ScheduleGame] {
        let allGames = schedule?.dates.flatMap { $0.games } ?? []
        return allGames.filter { game in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            guard let date = dateFormatter.date(from: game.gameDate) else { return false }
            let calendar = Calendar.current
            let gameMonth = calendar.component(.month, from: date)
            return gameMonth == month
        }
    }
    
    private func findLastTenGames() {
        guard let schedule = schedule else { return }
        
        let allGames = schedule.dates.flatMap { $0.games }
        let completedGames = allGames.filter { $0.status.abstractGameState == "Final" }
        let sortedGames = completedGames.sorted {
            guard let date1 = ISO8601DateFormatter().date(from: $0.gameDate),
                  let date2 = ISO8601DateFormatter().date(from: $1.gameDate) else {
                return false
            }
            return date1 > date2
        }
        lastTenGames = Array(sortedGames.prefix(10))
    }
    
    private func findTodaysGame() {
            let today = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let todayString = dateFormatter.string(from: today)
            
            todaysGame = schedule?.dates.first(where: { $0.date == todayString })?.games.first
            if let link = todaysGame?.link {
                print(link)
            }
        }
    
    private func findNextGame() {
            let today = Date()
            nextGame = schedule?.dates
                .flatMap { $0.games }
                .first { game in
                    if let gameDate = ISO8601DateFormatter().date(from: game.gameDate) {
                        return gameDate > today
                    }
                    return false
                }
        }
}

class CardinalsLiveViewModel: ObservableObject {
    @Published var liveFeed: LiveFeed?
    @Published var error: Error?
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    private let baseUrlString = "https://statsapi.mlb.com"
    
    func fetchLiveFeed(for link: String) {
        isLoading = true
        error = nil
        
        let urlString = "\(baseUrlString)\(link)"
        print(urlString)
        guard let url = URL(string: urlString) else {
            error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            isLoading = false
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: LiveFeed.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error
                }
            } receiveValue: { [weak self] liveFeed in
                self?.liveFeed = liveFeed
            }
            .store(in: &cancellables)
    }
}

class TodaysStatsViewModel: ObservableObject {
    @Published var roster = Roster(players: [])
    @Published var error: Error?
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    private let baseUrlString = "https://statsapi.mlb.com"
    private let teamId = 138
    
    func fetchRosterAndStats() {
        isLoading = true
        error = nil
        
        // Step 1: Get the roster
        let rosterUrlString = "\(baseUrlString)/api/v1/teams/\(teamId)/roster"
        guard let rosterUrl = URL(string: rosterUrlString) else {
            error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            isLoading = false
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: rosterUrl)
            .map(\.data)
            .decode(type: Roster.self, decoder: JSONDecoder())
            .flatMap { [weak self] roster -> AnyPublisher<Roster, Error> in
                guard let self = self else {
                    return Empty<Roster, Error>().eraseToAnyPublisher()
                }
                
                let playerIds = roster.players.map { String($0.id) }.joined(separator: ",")
                
                return self.fetchStats(for: playerIds, group: "hitting")
                    .combineLatest(self.fetchStats(for: playerIds, group: "pitching"))
                    .map { hittingStats, pitchingStats in
                        var updatedRoster = roster
                        for i in 0..<updatedRoster.players.count {
                            updatedRoster.players[i].stats.hitting = hittingStats[updatedRoster.players[i].id]
                            updatedRoster.players[i].stats.pitching = pitchingStats[updatedRoster.players[i].id]
                        }
                        return updatedRoster
                    }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error
                }
            } receiveValue: { [weak self] roster in
                self?.roster = roster
            }
            .store(in: &cancellables)
    }
    
    private func fetchStats(for playerIds: String, group: String) -> AnyPublisher<[Int: PlayerStats.StatDetail], Error> {
        let statsUrlString = "\(baseUrlString)/api/v1/stats?stats=season&group=\(group)&playerId=\(playerIds)"
        guard let statsUrl = URL(string: statsUrlString) else {
            return Fail(error: NSError(domain: "Invalid URL", code: 0, userInfo: nil)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: statsUrl)
            .map(\.data)
            .decode(type: StatsResponse.self, decoder: JSONDecoder())
            .map { response in
                var statsDict: [Int: PlayerStats.StatDetail] = [:]
                for stat in response.stats {
                    let playerId = stat.player.id
                    statsDict[playerId] = stat.stat
                }
                return statsDict
            }
            .eraseToAnyPublisher()
    }
}
