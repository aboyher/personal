////
////  ProfileStore.swift
////  TrackBaby
////
////  Created by Adam Boyher on 6/7/24.
////
//
//import SwiftUI
//
//@MainActor
//class ProfileStore: ObservableObject {
//    @Published var profiles: [Profile] = []
//    
//    private static func  fileURL() throws -> URL {
//        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//            .appendingPathComponent("profiles.data")
//    }
//    
//    func load() async throws {
//        let task = Task<[Profile], Error> {
//            let fileURL = try Self.fileURL()
//            guard let data = try? Data(contentsOf: fileURL) else {
//                return []
//            }
//            let readProfiles = try JSONDecoder().decode([Profile].self, from: data)
//            return readProfiles
//        }
//        let profiles = try await task.value
//        self.profiles = profiles
//        
//    }
//    
//    func save(profiles: [Profile]) async throws {
//        let task = Task {
//            let data = try JSONEncoder().encode(profiles)
//            let outfile = try Self.fileURL()
//            try data.write(to: outfile)
//        }
//        _ =  try await task.value
//    }
//}
