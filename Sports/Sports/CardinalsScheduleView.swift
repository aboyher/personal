//
//  ScheduleView.swift
//  Sports
//
//  Created by Adam Boyher on 8/14/24.
//

import SwiftUI

struct CardinalsScheduleView: View {
    @ObservedObject var viewModel: CardinalsScheduleViewModel
    
    private var currentMonth: Int {
        Calendar.current.component(.month, from: Date())
        
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            List {
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.error {
                    Text("Error: \(error.localizedDescription)")
                } else if let schedule = viewModel.schedule {
                    ForEach(1...12, id: \.self) { month in
                        Section(header: Text(DateFormatter().monthSymbols[month - 1]).id(month)) {
                            ForEach(viewModel.getGamesForMonth(month), id: \.gamePk) { game in
                                GameRow(game: game)
                            }
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(.white)
            .clipped()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        proxy.scrollTo(currentMonth, anchor: .top)
                    }
                }
            }
        }
    }
}

struct GameRow: View {
    let game: Schedule.ScheduleGame
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(game.teams.away.team.name) @ \(game.teams.home.team.name)")
            Text(game.gameDate)
                .font(.caption)
        }
    }
}
