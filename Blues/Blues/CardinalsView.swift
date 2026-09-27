//
//  CardinalsView.swift
//  Blues
//
//  Created by Adam Boyher on 8/12/24.
//

import SwiftUI


struct CardinalsView: View {
    @StateObject private var viewModel = CardinalsViewModel()

    var body: some View {
        TabView {
            TodayView(viewModel: viewModel)
                .tabItem {
                    Label("Today", systemImage: "calendar")
                }

            StandingsView(viewModel: viewModel)
                .tabItem {
                    Label("Standings", systemImage: "list.number")
                }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .refreshable {
            await viewModel.refreshAllData()
        }
        .onAppear {
            viewModel.fetchAllData()
            setupAppearance()
        }
    }
    func setupAppearance() {
      UIPageControl.appearance().currentPageIndicatorTintColor = .black
      UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
    }
}


#Preview {
    CardinalsView()
}
