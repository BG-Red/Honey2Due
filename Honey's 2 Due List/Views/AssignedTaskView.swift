//
//  AssignedTaskView.swift
//  Honey's 2 Due List
//
//  Created by Zachary Pierce on 6/14/25.
//

import SwiftUI

struct AssignedTasksView: View {
    @EnvironmentObject var appDataStore: AppDataStore

    var body: some View {
        NavigationView {
            List {
                ForEach(appDataStore.tasks.filter {
                    // Show tasks that are approved, in progress, or completed AND
                    // are assigned to the current user OR were submitted by the current user
                    ($0.status == .approved || $0.status == .inProgress || $0.status == .completed) &&
                    ($0.assignedToUserId == appDataStore.currentUser.id || $0.submittedByUserId == appDataStore.currentUser.id)
                }) { task in
                    NavigationLink {
                        // Re-use the TaskDetailView for viewing details and updates
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
            .navigationTitle("Assigned Tasks")
        }
    }
}

// MARK: - Preview
#Preview {
    AssignedTasksView()
        .environmentObject(AppDataStore())
}
