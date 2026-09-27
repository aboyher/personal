//
//  HomeView.swift
//  TrackBaby
//
//  Created by Adam Boyher on 6/8/24.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var profile: Profile
    @State var isSettingsViewActive = false
    @State var isMakeBabyViewActive = false
    @State var selectedBaby: Baby?
    
    var body: some View {
        NavigationStack {
            VStack {
                if let selectedBaby {
                    Menu(selectedBaby.name){
                        ForEach(profile.babies) { baby in
                            Button(baby.name){
                                switchBaby(baby: baby)
                            }
                        }
                    }
                    .font(.title)
                    .foregroundColor(selectedBaby.theme.mainColor)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(selectedBaby.theme.mainColor)
                            .frame(maxHeight: 300)
                    }
                    
                    Spacer()
                }
                
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu(content: {
                        Button("Settings"){
                            isSettingsViewActive = true
                        }
                    }, label: {Image(systemName: "line.3.horizontal.circle")})
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {isMakeBabyViewActive = true}){
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationDestination(isPresented: $isSettingsViewActive){
                SettingsView()
            }
            .navigationDestination(isPresented: $isMakeBabyViewActive){
                MakeBabyView(profile: profile)
            }
            
        }
        .onAppear {
            if selectedBaby == nil {
                if !profile.babies.isEmpty {
                    selectedBaby = profile.babies[0]
                }
            }
        }
    }
    private func switchBaby(baby: Baby) {
        selectedBaby = baby
    }
}
