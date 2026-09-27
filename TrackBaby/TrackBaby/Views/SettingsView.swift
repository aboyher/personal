//
//  SettingsView.swift
//  TrackBaby
//
//  Created by Adam Boyher on 6/8/24.
//

import SwiftUI
import SwiftData
struct SettingsView: View {
    @Environment(\.modelContext) var modelContext
    @Query private var profiles: [Profile]
    var body: some View {
        NavigationStack {
            List{
                Section("Profiles") {
                    ForEach(profiles) {profile in
                        NavigationLink(destination: ProfileView(profile: profile)) {
                            Label(profile.name, systemImage: "person")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: Profile.self)
}
