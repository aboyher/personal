//
//  CardinalsTodayView.swift
//  Sports
//
//  Created by Adam Boyher on 8/14/24.
//

import SwiftUI

struct CardinalsTodayView: View {
    @ObservedObject var scheduleViewModel: CardinalsScheduleViewModel
    @StateObject var viewModel = CardinalsLiveViewModel()
    @StateObject var statsModel = TodaysStatsViewModel()
    @State var isGameToday = false
    
    
    var body: some View {
        NavigationView {
                ScrollView {
                    if viewModel.isLoading {
                        ProgressView()
                    } else if let error = viewModel.error {
                        Text("Error: \(error.localizedDescription)")
                    } else if let liveFeed = viewModel.liveFeed {
                        VStack(alignment: .leading, spacing: 20) {
                            gameHeader(liveFeed)
                            if liveFeed.gameData.status.abstractGameState == "Live" {
                                scoreboardView(liveFeed)
                                currentPlayView(liveFeed)
                                linescoreView(liveFeed)
                            }
                            StatsView(statsModel: statsModel)
                        }
                        .padding()
                    } else if let liveFeed = viewModel.liveFeed {
                        NextGameView(liveFeed: liveFeed)
                    } else {
                        Text("What's going on?")
                    }
                }
                .onAppear {
                    loadGameData()
                }
        }
    }
    
    private func loadGameData() {
        if let todaysGame = scheduleViewModel.todaysGame {
                isGameToday = true
                viewModel.fetchLiveFeed(for: todaysGame.link)
            } else if let nextGame = scheduleViewModel.nextGame {
                isGameToday = false
                viewModel.fetchLiveFeed(for: nextGame.link)
                print(viewModel.liveFeed?.gameData.teams.home.clubName)
            }
        statsModel.fetchRosterAndStats()
        }
    
    
    private func gameHeader(_ liveFeed: LiveFeed) -> some View {
        VStack(alignment: .center) {
            Text("\(liveFeed.gameData.teams.away.clubName) @ \(liveFeed.gameData.teams.home.clubName)")
                .font(.headline)
            Text("\(liveFeed.gameData.venue.location.city), \(liveFeed.gameData.venue.location.state)")
                .font(.subheadline)
            Text(formattedDate(liveFeed.gameData.datetime.dateTime))
                .font(.caption)
        }
    }
    
    private func scoreboardView(_ liveFeed: LiveFeed) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(liveFeed.gameData.teams.away.abbreviation)
                Text(liveFeed.gameData.teams.home.abbreviation)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("\(String(describing: liveFeed.liveData.linescore.teams.away.runs))")
                Text("\(String(describing: liveFeed.liveData.linescore.teams.home.runs))")
            }
        }
        .font(.title)
    }
    
    private func currentPlayView(_ liveFeed: LiveFeed) -> some View {
        VStack(alignment: .leading) {
            Text("Current Play")
                .font(.headline)
            Text(liveFeed.liveData.plays.currentPlay?.result.description ?? "No current play")
                .font(.body)
        }
    }
    
    private func linescoreView(_ liveFeed: LiveFeed) -> some View {
        VStack(alignment: .leading) {
            Text("Linescore")
                .font(.headline)
            
            HStack {
                Text("Team")
                ForEach(1...9, id: \.self) { inning in
                    Text("\(inning)")
                        .frame(width: 20)
                }
                Text("R")
                Text("H")
                Text("E")
            }
            .font(.caption)
            
            LinescoreRow(team: liveFeed.gameData.teams.away.abbreviation, linescore: liveFeed.liveData.linescore, isAway: true)
            LinescoreRow(team: liveFeed.gameData.teams.home.abbreviation, linescore: liveFeed.liveData.linescore, isAway: false)
        }
    }
    
    private func formattedDate(_ dateString: String) -> String {
        let inputFormatter = ISO8601DateFormatter()
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMM d, yyyy h:mm a"
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        } else {
            return dateString
        }
    }
}

struct LinescoreRow: View {
    let team: String
    let linescore: LiveFeed.Linescore
    let isAway: Bool
    
    var body: some View {
        HStack {
            Text(team)
                .frame(width: 40, alignment: .leading)
            ForEach(1...9, id: \.self) { inning in
                Text(runsForInning(inning))
                    .frame(width: 20)
            }
            Text("\(String(describing: isAway ? linescore.teams.away.runs : linescore.teams.home.runs))")
            Text("\(String(describing: isAway ? linescore.teams.away.hits : linescore.teams.home.hits))")
            Text("\(String(describing: isAway ? linescore.teams.away.errors : linescore.teams.home.errors))")
        }
        .font(.caption)
    }
    
    private func runsForInning(_ inning: Int) -> String {
        guard let innings = linescore.innings, inning <= innings.count else { return "-" }
        let inningData = innings[inning - 1]
        let runs = isAway ? inningData.away.runs : inningData.home.runs
        return runs.description
    }
}

struct NextGameView: View {
    let liveFeed: LiveFeed
    
    var body: some View {
        if isDateTomorrow(liveFeed.gameData.datetime.officialDate) {
                Text("TOMORROW")
                .font(.title)
        } else {
            Text(formattedDate(liveFeed.gameData.datetime.officialDate))
        }
        HStack {
            Text("\(liveFeed.gameData.teams.away.clubName)")
                .bold(liveFeed.gameData.teams.away.clubName == "Cardinals")
            Text("@")
            Text("\(liveFeed.gameData.teams.home.clubName)")
                .bold(liveFeed.gameData.teams.home.clubName == "Cardinals")
        }
        Text(formattedTime(liveFeed.gameData.datetime.officialDate))
        Text(liveFeed.gameData.probablePitchers.away.fullName)
        
        
    }
    
    func isDateTomorrow(_ dateString: String) -> Bool {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        
        guard let date = formatter.date(from: dateString) else {
            print("Failed to parse date string")
            return false
        }
        
        // Convert date to CST
        let cstTimeZone = TimeZone(identifier: "America/Chicago")!
        let calendar = Calendar.current
        let cstDate = calendar.date(byAdding: .second, value: cstTimeZone.secondsFromGMT(for: date) - TimeZone.current.secondsFromGMT(for: date), to: date)!
        
        return calendar.isDateInTomorrow(cstDate)
    }
    
    private func formattedDate(_ dateString: String) -> String {
            let inputFormatter = ISO8601DateFormatter()
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "EEEE, MMM d"
            
            if let date = inputFormatter.date(from: dateString) {
                return outputFormatter.string(from: date)
            } else {
                return dateString
            }
        }
    
    private func formattedTime(_ dateString: String) -> String {
            let inputFormatter = ISO8601DateFormatter()
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "h:mm a"
            
            if let date = inputFormatter.date(from: dateString) {
                return outputFormatter.string(from: date)
            } else {
                return dateString
            }
        }
}


struct StatsView: View {
    @ObservedObject var statsModel: TodaysStatsViewModel
    
    var body: some View {
        List(statsModel.roster.players) { player in
            VStack(alignment: .leading) {
                Text(player.fullName)
                    .font(.headline)
                
                if let hitting = player.stats.hitting {
                    Text("Hitting Stats")
                    Text("Hits: \(hitting.hits ?? 0)")
                    Text("Home Runs: \(hitting.homeRuns ?? 0)")
                    // More hitting stats
                }
                
                if let pitching = player.stats.pitching {
                    Text("Pitching Stats")
                    Text("Strike Outs: \(pitching.strikeOuts ?? 0)")
                    Text("ERA: \(pitching.earnedRunAverage ?? 0.0)")
                    // More pitching stats
                }
            }
        }
    }
}
