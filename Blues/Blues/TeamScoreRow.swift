//
//  TeamScoreRow.swift
//  Blues
//
//  Created by Adam Boyher on 8/12/24.
//

import SwiftUI

struct TeamScoreRow: View {
    let teamName: String
    let score: Int
    let isWinning: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Text(teamName)
                .font(.headline)
                .foregroundColor(isWinning ? .primary : .secondary)
            
            Text("\(score)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(isWinning ? .primary : .secondary)
        }
    }
}
