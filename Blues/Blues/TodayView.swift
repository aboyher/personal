//
//  TodayView.swift
//  Blues
//
//  Created by Adam Boyher on 8/12/24.
//

import SwiftUI

struct TodayView: View {
    @ObservedObject var viewModel: CardinalsViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let todaysGame = viewModel.todaysGame {
                    GameCard(game: todaysGame)
                }

                Divider()

                VStack(alignment: .leading, spacing: 10) {
                    Text("Recent News")
                        .font(.headline)

                    ForEach(viewModel.newsItems) { item in
                        NewsItemView(item: item)
                    }
                }
            }
            .padding()

        }
        .navigationTitle("Cardinals")
    }
}
