//
//  TasksNeedingQuoteView.swift
//  Honey's 2 Due List
//
//  Created by Zachary Pierce on 6/14/25.
//

import SwiftUI
import SwiftData

struct TasksNeedingQuoteView: View {
    @EnvironmentObject var appDataStore: AppDataStore
    
    // 1. Fetch all tasks from SwiftData
    @Query private var tasks: [Task]

    // 2. Create a computed property to handle the complex filtering logic
    private var filteredTasks: [Task] {
        tasks.filter { task in
            // Condition 1: Task is pending a quote
            let isPendingQuote = task.status == .pendingQuote
            
            // Condition 2: An edited quote needs your re-approval.
            // This logic is for Person A to see a quote that Person B has edited and sent back.
            let needsReApproval = task.status == .quoteSubmitted &&
                                  task.currentQuote?.submittedByUserId != appDataStore.currentUser.id &&
                                  task.currentQuote?.status == .editedAndResubmitted
            
            return isPendingQuote || needsReApproval
        }
    }

    var body: some View {
        NavigationView {
            // 3. Use the simple computed property in the List
            List(filteredTasks) { task in
                NavigationLink {
                    CreateQuoteView(task: task)
                } label: {
                    VStack(alignment: .leading) {
                        Text(task.title)
                            .font(.headline)
                        Text(task.details) // Using 'details'
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        // Awaiting re-approval status message
                        if task.status == .quoteSubmitted &&
                           task.currentQuote?.status == .editedAndResubmitted {
                            Text("Awaiting Your Re-Approval")
                                .font(.caption)
                                .foregroundColor(.orange)
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
    // For previews to work with SwiftData, you need to provide a sample model container.
    // .modelContainer(for: [Task.self, Quote.self], inMemory: true)
}
