//
//  ProfileView.swift
//  TrackBaby
//
//  Created by Adam Boyher on 6/8/24.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var profile: Profile
    var body: some View {
        Text(profile.name)
        List {
            Section("Babies") {
                ForEach(profile.babies) { baby in
                    NavigationLink(destination: EditBabyView(profile: profile, baby: baby, name: baby.name, gender: baby.gender, theme: baby.theme)) {
                        Text(baby.name)
                            .swipeActions {
                                Button("Delete", systemImage: "trash", role: .destructive) {
                                    deleteBaby(baby: baby)
                                }
                            }
                    }
                }
            }
        }
    }
    private func deleteBaby(baby: Baby){
        modelContext.delete(baby)
    }
}
