//
//  AssignedTaskView.swift
//  Honey's 2 Due List
//
//  Created by Zachary Pierce on 6/14/25.
//

import SwiftUI
import SwiftData

struct AssignedTaskView: View {
    @EnvironmentObject var appDataStore: AppDataStore
    
    // 1. Fetch all tasks from SwiftData
    @Query private var tasks: [Task]

    // 2. Use a computed property to break down the complex filtering logic
    private var filteredTasks: [Task] {
        tasks.filter { task in
            // Condition: Is the task in a state to be displayed in this list?
            let isRelevantStatus = task.status == .approved ||
                                   task.status == .inProgress ||
                                   task.status == .completed
            
            // Condition: Is the task related to the current user?
            let isUserRelated = task.assignedToUserId == appDataStore.currentUser.id ||
                                task.submittedByUserId == appDataStore.currentUser.id
            
            return isRelevantStatus && isUserRelated
        }
    }

    var body: some View {
        NavigationView {
            // 3. Use the simple computed property in the List
            List(filteredTasks) { task in
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
            .navigationTitle("Assigned Tasks")
        }
    }
}

#Preview {
    AssignedTaskView()
        .environmentObject(AppDataStore())
    //.modelContainer(for: [Task.self], inMemory: true)
}
