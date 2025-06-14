//
//  TaskDetailView.swift
//  Honey's 2 Due List
//
//  Created by Zachary Pierce on 6/14/25.
//

import SwiftUI

struct TaskDetailView: View {
    @EnvironmentObject var appDataStore: AppDataStore
    // @State here allows the view to re-render when its own `task` property changes.
    // It's also updated when the `appDataStore.tasks` array changes via onChange.
    @State var task: Task
    @State private var updateMessage: String = ""
    @State private var showingEditQuoteSheet = false

    // Computed property to get the most up-to-date task from the data store.
    // This ensures the UI always reflects the latest state from our source of truth.
    private var currentTask: Task {
        appDataStore.tasks.first(where: { $0.id == task.id }) ?? task
    }

    var body: some View {
        ScrollView { // Allows content to scroll if it exceeds screen height
            VStack(alignment: .leading, spacing: 20) { // Main vertical stack for content
                // MARK: - Task Info
                VStack(alignment: .leading, spacing: 5) {
                    Text(currentTask.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Status: \(currentTask.status.rawValue)")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("Submitted by: \(appDataStore.currentUser.id == currentTask.submittedByUserId ? "You" : (currentTask.submittedByUserId == User.personA.id ? User.personA.name : User.personB.name))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("Description:")
                        .font(.headline)
                        .padding(.top, 5)
                    Text(currentTask.description)
                        .font(.body)
                }
                .padding(.horizontal)


                // MARK: - Quote Section
                if let quote = currentTask.currentQuote { // Only show if a quote exists
                    Divider() // Separator line
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Current Quote")
                            .font(.title2)
                            .fontWeight(.semibold)

                        // Reusable helper view for displaying quote details
                        QuoteDetailRow(label: "Timeframe", value: quote.timeframe)
                        QuoteDetailRow(label: "Materials", value: quote.materials)
                        QuoteDetailRow(label: "Restrictions", value: quote.restrictions)
                        QuoteDetailRow(label: "Reward", value: quote.reward)
                        QuoteDetailRow(label: "Quote Status", value: quote.status.rawValue)

                        // Action buttons for the submitter (Person A) to review quote
                        if currentTask.submittedByUserId == appDataStore.currentUser.id && currentTask.status == .quoteSubmitted {
                            HStack {
                                Button("Approve Quote") {
                                    appDataStore.approveQuote(for: currentTask)
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.green) // Green accent for approval

                                Button("Edit Quote") {
                                    showingEditQuoteSheet = true // Show the sheet to edit
                                }
                                .buttonStyle(.bordered)
                            }
                            .padding(.top, 10)
                        } else if currentTask.assignedToUserId == appDataStore.currentUser.id && currentTask.status != .completed && currentTask.status != .cancelled {
                            // Assignee can update task status if it's assigned to them and not yet completed/cancelled
                            Picker("Update Task Status", selection
