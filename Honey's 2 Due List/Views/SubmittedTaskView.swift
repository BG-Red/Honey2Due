//
//  SubmittedTaskView.swift
//  Honey's 2 Due List
//
//  Created by Zachary Pierce on 6/14/25.
//

import SwiftUI

struct SubmittedTaskView: View {
    @EnvironmentObject var appDataStore: AppDataStore

    var body: some View {
        NavigationView {
            List {
                // Filter tasks to show only those submitted by the current user
                ForEach(appDataStore.tasks.filter { $0.submittedByUserId == appDataStore.currentUser.id }) { task in
                    NavigationLink {
                        // Tapping on a task navigates to its detail view
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
            .navigationTitle("My Requests") // Title for this navigation stack
        }
    }
}

// MARK: - Preview
// This code block allows you to see a preview of this view in Xcode's canvas
#Preview {
    SubmittedTaskView()
        .environmentObject(AppDataStore()) // Provide a dummy AppDataStore for the preview
}
