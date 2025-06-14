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

    // State for the picker selection
    @State private var selectedStatus: TaskStatus = .inProgress // Default for assignee to update


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

                    // Display Requested Dates and Priority if available
                    if let startDate = currentTask.requestedStartDate {
                        Text("Requested Start: \(startDate.formatted(date: .numeric, time: .omitted))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    if let completionDate = currentTask.completionDate {
                        Text("Target Completion: \(completionDate.formatted(date: .numeric, time: .omitted))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Text("Priority: \(currentTask.priority.rawValue)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    if let requestedReward = currentTask.requestedReward, !requestedReward.isEmpty {
                        Text("Requested Reward: \(requestedReward)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
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
                            Picker("Update Task Status", selection: $selectedStatus) {
                                ForEach(TaskStatus.allCases.filter { $0 != .pendingQuote && $0 != .quoteSubmitted && $0 != .quoteReviewed && $0 != .approved && $0 != .cancelled }) { statusCase in
                                    Text(statusCase.rawValue).tag(statusCase)
                                }
                            }
                            .pickerStyle(.menu) // Or .segmented
                            .onChange(of: selectedStatus) { oldStatus, newStatus in
                                appDataStore.updateTaskStatus(for: currentTask, newStatus: newStatus)
                            }
                            .onAppear {
                                // Set initial picker value to current task status
                                selectedStatus = currentTask.status
                            }
                            .padding(.top, 10)
                        }
                    }
                }

                // MARK: - Task Updates Section
                Divider()
                VStack(alignment: .leading, spacing: 10) {
                    Text("Updates")
                        .font(.title2)
                        .fontWeight(.semibold)

                    ForEach(currentTask.updates.sorted(by: { $0.timestamp > $1.timestamp })) { update in
                        VStack(alignment: .leading) {
                            Text("\(update.message)")
                                .font(.body)
                            Text("– \(appDataStore.getUserName(for: update.userId)) on \(update.timestamp.formatted(date: .numeric, time: .shortened))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.bottom, 5)
                    }

                    TextField("Add a new update...", text: $updateMessage)
                        .textFieldStyle(.roundedBorder)
                    Button("Post Update") {
                        if !updateMessage.isEmpty {
                            appDataStore.addUpdate(to: currentTask, message: updateMessage)
                            updateMessage = ""
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(updateMessage.isEmpty)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Task Details")
        .navigationBarTitleDisplayMode(.inline) // Keep title compact
        .sheet(isPresented: $showingEditQuoteSheet) {
            CreateQuoteView(task: currentTask, isEditing: true)
        }
        .onChange(of: appDataStore.tasks) { oldTasks, newTasks in // Update @State task when appDataStore changes
            if let updated = newTasks.first(where: { $0.id == task.id }) {
                task = updated
            }
        }
    }

    // Helper to get user name (you might already have this in AppDataStore)
    // If not, you'd add a helper function in AppDataStore.
    // For now, let's add a placeholder here for compilation if AppDataStore doesn't have it.
    private func getUserName(for userId: UUID) -> String {
        if userId == User.personA.id {
            return User.personA.name
        } else if userId == User.personB.id {
            return User.personB.name
        }
        return "Unknown User"
    }
}
