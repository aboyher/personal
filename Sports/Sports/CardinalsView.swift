//
//  CardinalsView.swift
//  Sports
//
//  Created by Adam Boyher on 8/14/24.
//

import SwiftUI

struct CardinalsView: View {
    @StateObject private var scheduleViewModel = CardinalsScheduleViewModel()
    
    var body: some View {
        TabView {
            CardinalsTodayView(scheduleViewModel: scheduleViewModel)
                .tabItem {
                    Label("Today", systemImage: "sun.horizon")
                }
            CardinalsLastTenView(viewModel: scheduleViewModel)
                .tabItem {
                    Label("Last 10", systemImage: "gobackward.10")
                }
            CardinalsScheduleView(viewModel: scheduleViewModel)
                .tabItem {
                    Label("Schedule", systemImage: "calendar")
                }
        }
        .onAppear {
            scheduleViewModel.fetchSchedule()
        }
    }
}

#Preview {
    CardinalsView()
}
