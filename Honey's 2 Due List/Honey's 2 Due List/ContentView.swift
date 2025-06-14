//
//  ContentView.swift
//  Honey's 2 Due List
//
//  Created by Zachary Pierce on 6/14/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appDataStore: AppDataStore

    var body: some View {
        // Allows switching between users for testing the flow
        // In a real app, this would be a login/profile screen
        VStack {
            Picker("Current User", selection: $appDataStore.currentUser) {
                Text(User.personA.name).tag(User.personA)
                Text(User.personB.name).tag(User.personB)
            }
            .pickerStyle(.segmented)
            .padding()

            TabView {
                // Submitted Tasks (Person A's view)
                SubmittedTasksView()
                    .tabItem {
                        Label("My Requests", systemImage: "paperplane.fill")
                    }

                // Tasks Needing Quote (Person B's view)
                TasksNeedingQuoteView()
                    .tabItem {
                        Label("To Quote", systemImage: "text.bubble.fill")
                    }

                // Assigned Tasks (Both can see, but specific to who it's assigned to)
                AssignedTasksView()
                    .tabItem {
                        Label("Assigned", systemImage: "checklist.checked")
                    }

                // Add New Task
                NewTaskView()
                    .tabItem {
                        Label("New Task", systemImage: "plus.circle.fill")
                    }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppDataStore())
}
