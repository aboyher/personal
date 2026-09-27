//
//  ContentView.swift
//  Sports
//
//  Created by Adam Boyher on 8/14/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTeam = "Cardinals"
    var body: some View {
        NavigationStack {
            Group {
                
                if selectedTeam == "Cardinals" {
                    CardinalsView()
                } else if selectedTeam == "Blues" {
                    Text("Blues")
                }
            }
            .toolbar{
                ToolbarItem (placement: .navigationBarTrailing) {
                    Button {
                        selectedTeam = "Blues"
                    } label: {
                        Image(systemName: "hockey.puck.circle")
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(selectedTeam == "Blues" ? .white : .yellow)
                        .background(selectedTeam == "Blues" ? Color.gray : Color.blue)
                        .clipShape(Circle())
                        
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text(selectedTeam)
                        .foregroundColor(.white)
                        .background(selectedTeam == "Cardinals" ? Color.red : Color.blue)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        selectedTeam = "Cardinals"
                    } label: {
                        Image(systemName: "baseball.circle")
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                        .background(selectedTeam == "Cardinals" ? Color.gray : Color.red)
                        .clipShape(Circle())
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
