//
//  HomeView.swift
//  TrackBaby
//
//  Created by Adam Boyher on 6/7/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query
    @State private var profile: Profile?
    
    var body: some View {
        NavigationStack {
            if let profile {
                HomeView(profile: profile)
                
            } else {
                CreateProfileView()
            }
        }
        .onAppear {
            load()
        }
    }
    
    func load() {
            let request = FetchDescriptor<Profile>()
            let data = try? modelContext.fetch(request)
        profile = data?.first ?? nil
        
        }
}

#Preview {
    ContentView()
        .modelContainer(for: Profile.self)
}
