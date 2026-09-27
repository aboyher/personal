//
//  NewsSection.swift
//  Blues
//
//  Created by Adam Boyher on 8/12/24.
//

import SwiftUI

struct NewsSection: View {
    let newsItems: [NewsItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Recent News")
                .font(.headline)

            ForEach(newsItems) { item in
                NewsItemView(item: item)
            }
        }
    }
}

struct NewsItemView: View {
    let item: NewsItem

    var body: some View {
        Link(destination: URL(string: item.link)!) {
            VStack(alignment: .leading, spacing: 5) {
                Text(item.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Text(item.description.prefix(100) + "...")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(item.pubDate, style: .date)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(10)
        }
    }
}
