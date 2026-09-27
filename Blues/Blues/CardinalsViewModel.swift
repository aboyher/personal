//
//  CardinalsViewModel.swift
//  Blues
//
//  Created by Adam Boyher on 8/12/24.
//

import Foundation
import FeedKit

@MainActor
class CardinalsViewModel: ObservableObject {
    @Published var todaysGame: Game?
    @Published var pastGames: [Game] = []
    @Published var seasonRecord: Record?
    @Published var lastTenRecord: Record?
    @Published var divisionStandings: [TeamStanding] = []
    @Published var playoffStatus: String = ""
    @Published var newsItems: [NewsItem] = []
    
    private let cardinalsId = 138
    private let cardinalsDivisionId = 205 // NL Central

//    @MainActor
    func fetchAllData() {
        Task {
            await refreshAllData()
        }
    }
    
//    @MainActor
    func refreshAllData() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.fetchGames() }
            group.addTask { await self.fetchStandings() }
            group.addTask { await self.fetchNews() }
        }
    }

    private func fetchGames() async {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let endDate = Date()
            let startDate = Calendar.current.date(byAdding: .day, value: -20, to: endDate)!
            
            let urlString = "https://statsapi.mlb.com/api/v1/schedule?teamId=\(cardinalsId)&sportId=1&startDate=\(dateFormatter.string(from: startDate))&endDate=\(dateFormatter.string(from: endDate))&hydrate=linescore"
            
            guard let url = URL(string: urlString) else { return }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let scheduleResponse = try decoder.decode(ScheduleResponse.self, from: data)
                
                var games = scheduleResponse.dates.flatMap { dateSchedule -> [Game] in
                    dateSchedule.games.compactMap { gameResponse in
                        let homeTeam = gameResponse.teams.home
                        let awayTeam = gameResponse.teams.away
                        let isCardinalsHomeTeam = homeTeam.team.id == self.cardinalsId
                        
                        let boxscore = Boxscore(
                            home: TeamBoxscore(
                                runs: gameResponse.linescore?.teams.home.runs ?? 0,
                                hits: gameResponse.linescore?.teams.home.hits ?? 0,
                                errors: gameResponse.linescore?.teams.home.errors ?? 0,
                                leftOnBase: gameResponse.linescore?.teams.home.leftOnBase ?? 0
                            ),
                            away: TeamBoxscore(
                                runs: gameResponse.linescore?.teams.away.runs ?? 0,
                                hits: gameResponse.linescore?.teams.away.hits ?? 0,
                                errors: gameResponse.linescore?.teams.away.errors ?? 0,
                                leftOnBase: gameResponse.linescore?.teams.away.leftOnBase ?? 0
                            )
                        )

                        return Game(
                            id: gameResponse.gamePk,
                            date: ISO8601DateFormatter().date(from: gameResponse.gameDate)!,
                            homeTeam: homeTeam.team.name,
                            awayTeam: awayTeam.team.name,
                            homeScore: homeTeam.score ?? 0,
                            awayScore: awayTeam.score ?? 0,
                            isWinner: isCardinalsHomeTeam ? homeTeam.isWinner : awayTeam.isWinner,
                            status: gameResponse.status.abstractGameState,
                            venue: gameResponse.venue.name,
                            inning: gameResponse.linescore?.currentInning,
                            isTopInning: gameResponse.linescore?.isTopInning,
                            balls: gameResponse.linescore?.balls,
                            strikes: gameResponse.linescore?.strikes,
                            outs: gameResponse.linescore?.outs,
                            boxscore: boxscore
                        )
                    }
                }
                
                let today = Calendar.current.startOfDay(for: Date())
                if let todayGame = games.first(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
                    if todayGame.status != "Preview" {
                        // Fetch detailed linescore for today's game
                        if let detailedLinescore = await fetchDetailedLinescore(for: todayGame.id) {
                            var updatedTodayGame = todayGame
                            updatedTodayGame.detailedLinescore = detailedLinescore
                            self.todaysGame = updatedTodayGame
                        } else {
                            self.todaysGame = todayGame
                        }
                    } else {
                        self.todaysGame = todayGame
                    }
                }
                
                self.pastGames = games.filter { $0.date < today && $0.status == "Final" }.prefix(10).map { $0 }
            } catch {
                print("Error fetching games: \(error)")
            }
        }

        private func fetchDetailedLinescore(for gamePk: Int) async -> DetailedLinescore? {
            let urlString = "https://statsapi.mlb.com/api/v1.1/game/\(gamePk)/feed/live"
            guard let url = URL(string: urlString) else { return nil }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let liveFeedResponse = try JSONDecoder().decode(LiveFeedResponse.self, from: data)
                var linescore = liveFeedResponse.liveData.linescore
                linescore.homeTeam = liveFeedResponse.gameData.teams.home.team.name
                linescore.awayTeam = liveFeedResponse.gameData.teams.away.team.name
                return liveFeedResponse.liveData.linescore
            } catch {
                print("Error fetching detailed linescore: \(error)")
                return nil
            }
        }

        private func fetchStandings() async {
            let urlString = "https://statsapi.mlb.com/api/v1/standings?leagueId=104&season=2024"
            
            guard let url = URL(string: urlString) else { return }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let standingsResponse = try JSONDecoder().decode(StandingsResponse.self, from: data)
                
                if let divisionRecord = standingsResponse.records.first(where: { $0.division.id == self.cardinalsDivisionId }) {
                    self.divisionStandings = divisionRecord.teamRecords.map { record in
                        TeamStanding(
                            name: record.team.name,
                            wins: record.leagueRecord.wins,
                            losses: record.leagueRecord.losses,
                            gamesBack: record.gamesBack
                        )
                    }
                    
                    if let cardinalsRecord = divisionRecord.teamRecords.first(where: { $0.team.id == self.cardinalsId }) {
                        self.seasonRecord = cardinalsRecord.leagueRecord
                        self.lastTenRecord = cardinalsRecord.records.splitRecords.first(where: { $0.type == "lastTen" }).map { Record(wins: $0.wins, losses: $0.losses, pct: "") }
                        
                        // Determine playoff status
                        if let wildCardGamesBack = cardinalsRecord.wildCardGamesBack {
                            self.playoffStatus = "Games back of Wild Card: \(wildCardGamesBack)"
                        } else if cardinalsRecord.wildCardRank == "1" || cardinalsRecord.divisionRank == "1" {
                            self.playoffStatus = "In playoff position"
                        } else {
                            self.playoffStatus = "Out of playoffs"
                        }
                    }
                }
            } catch {
                print("Error fetching standings: \(error)")
            }
        }
    
    func fetchNews() async {
            let urlString = "https://www.mlb.com/cardinals/feeds/news/rss.xml"
            guard let url = URL(string: urlString) else { return }

            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let parser = FeedParser(data: data)
                let result = parser.parse()
                
                switch result {
                case .success(let feed):
                    if let rssFeed = feed.rssFeed {
                        DispatchQueue.main.async {
                            let last24Hours = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
                            self.newsItems = rssFeed.items?.compactMap { item in
                                guard let title = item.title,
                                      let pubDate = item.pubDate,
                                      pubDate > last24Hours,
                                      let link = item.link else { return nil }
                                
                                return NewsItem(
                                    id: title.hashValue,
                                    title: title,
                                    description: item.description ?? "",
                                    pubDate: pubDate,
                                    link: link
                                )
                            } ?? []
                        }
                    }
                case .failure(let error):
                    print("Error parsing feed: \(error)")
                }
            } catch {
                print("Error fetching news: \(error)")
            }
        }
}
