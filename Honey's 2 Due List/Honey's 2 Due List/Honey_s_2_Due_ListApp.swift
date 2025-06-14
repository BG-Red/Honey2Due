//
//  Honey_s_2_Due_ListApp.swift
//  Honey's 2 Due List
//
//  Created by Zachary Pierce on 6/14/25.
//

import SwiftUI
import SwiftData

@main
struct Honey_s_2_Due_ListApp: App {
    @StateObject var appDataStore = AppDataStore() // Create a single source of truth

        var body: some Scene {
            WindowGroup {
                ContentView()
                    .environmentObject(appDataStore) // Make it available to all child views
            }
        }
    }
