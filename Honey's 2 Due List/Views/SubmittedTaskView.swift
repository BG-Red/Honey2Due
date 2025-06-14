//
//  SubmittedTaskView.swift
//  Honey's 2 Due List
//
//  Created by Zachary Pierce on 6/14/25.
//

import SwiftUI
import SwiftData

struct SubmittedTaskView: View {
    @EnvironmentObject var appDataStore: AppDataStore
    
    // Query that fetches tasks and filters them by the current user's ID.
    // It automatically updates when data changes.
    @Query private var tasks: [Task]

    var body: some View {
        NavigationView {
            List {
                // Filter the results in-memory
                ForEach(tasks.filter { $0.submittedByUserId == appDataStore.currentUser.id }) { task in
                    NavigationLink {
                        TaskDetailView(task: task)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(task.title)
                                .font(.headline)
                            Text("Status: \(task.status.rawValue)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            if let quote = task.currentQuote {
                                Text("Reward: \(quote.reward)")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .navigationTitle("My Requests")
        }
    }
}
