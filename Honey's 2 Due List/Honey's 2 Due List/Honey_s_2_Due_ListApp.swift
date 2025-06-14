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
    // This AppDataStore is just for the user-switching simulation.
    // All task-related data is now handled by SwiftData.
    @StateObject var appDataStore = AppDataStore()

    // Define the model container with the CloudKit identifier
    var sharedModelContainer: ModelContainer = {
        // 1. Define the schema with all your @Model classes
        let schema = Schema([
            Task.self,
            Quote.self,
            TaskUpdate.self,
            Item.self
        ])
        
        // 2. Create a specific configuration for your CloudKit container
        //    ⚠️ Remember to replace the identifier with your own from the Xcode project settings.
        let modelConfiguration = ModelConfiguration(
            "iCloud.com.yourcompany.Honey2DueList"
        )

        // 3. Create the container using both the schema and the configuration
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appDataStore) // Still needed for currentUser
        }
        .modelContainer(sharedModelContainer) // Inject the container
    }
}
