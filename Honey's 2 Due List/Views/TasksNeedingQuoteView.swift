//
//  TasksNeedingQuoteView.swift
//  Honey's 2 Due List
//
//  Created by Zachary Pierce on 6/14/25.
//

import SwiftUI

struct TasksNeedingQuoteView: View {
    @EnvironmentObject var appDataStore: AppDataStore

    var body: some View {
        NavigationView {
            List {
                ForEach(appDataStore.tasks.filter {
                    // Show tasks that are pending a quote OR
                    // tasks that have a quote submitted by the current user AND
                    // that quote has been edited and resubmitted by the other user (Person A)
                    $0.status == .pendingQuote ||
                    ($0.status == .quoteSubmitted && $0.currentQuote?.submittedByUserId == appDataStore.currentUser.id && $0.currentQuote?.status == .editedAndResubmitted)
                }) { task in
                    NavigationLink {
                        // Pass 'true' to isEditing if the quote has been edited and needs re-approval
                        CreateQuoteView(task: task, isEditing: task.status == .quoteSubmitted)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(task.title)
                                .font(.headline)
                            Text(task.description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            if task.status == .quoteSubmitted {
                                Text("Awaiting Your Re-Approval")
                                    .font(.caption)
                                    .foregroundColor(.orange)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Tasks to Quote")
        }
    }
}

// MARK: - Preview
#Preview {
    TasksNeedingQuoteView()
        .environmentObject(AppDataStore())
}
