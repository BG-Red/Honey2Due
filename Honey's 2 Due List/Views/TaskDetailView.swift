//
//  TaskDetailView.swift
//  Honey's 2 Due List
//
//  Created by Zachary Pierce on 6/14/25.
//

import SwiftUI

struct TaskDetailView: View {
    @EnvironmentObject var appDataStore: AppDataStore
    @State var task: Task
    @State private var updateMessage: String = ""
    @State private var showingEditQuoteSheet = false

    // State for the picker selection
    @State private var selectedStatus: TaskStatus = .inProgress

    // Computed property to get the most up-to-date task from the data store
    private var currentTask: Task {
        appDataStore.tasks.first(where: { $0.id == task.id }) ?? task
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                taskInfoSection
                quoteSection
                updatesSection
            }
            .padding(.horizontal)
        }
        .navigationTitle("Task Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEditQuoteSheet) {
            CreateQuoteView(task: currentTask, isEditing: true)
        }
        .onChange(of: appDataStore.tasks) { newTasks in
            if let updated = newTasks.first(where: { $0.id == task.id }) {
                task = updated
            }
        }
    }

    // MARK: - Subviews

    private var taskInfoSection: some View {
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
    }

    @ViewBuilder
    private var quoteSection: some View {
        if let quote = currentTask.currentQuote {
            Divider()
            VStack(alignment: .leading, spacing: 10) {
                Text("Current Quote")
                    .font(.title2)
                    .fontWeight(.semibold)

                QuoteDetailRow(label: "Timeframe", value: quote.timeframe)
                QuoteDetailRow(label: "Materials", value: quote.materials)
                QuoteDetailRow(label: "Restrictions", value: quote.restrictions)
                QuoteDetailRow(label: "Reward", value: quote.reward)
                QuoteDetailRow(label: "Quote Status", value: quote.status.rawValue)

                if currentTask.submittedByUserId == appDataStore.currentUser.id && currentTask.status == .quoteSubmitted {
                    HStack {
                        Button("Approve Quote") {
                            appDataStore.approveQuote(for: currentTask)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)

                        Button("Edit Quote") {
                            showingEditQuoteSheet = true
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding(.top, 10)
                } else if currentTask.assignedToUserId == appDataStore.currentUser.id &&
                            currentTask.status != .completed &&
                            currentTask.status != .cancelled {
                    Picker("Update Task Status", selection: $selectedStatus) {
                        ForEach(TaskStatus.allCases.filter {
                            ![.pendingQuote, .quoteSubmitted, .quoteReviewed, .approved, .cancelled].contains($0)
                        }) { statusCase in
                            Text(statusCase.rawValue).tag(statusCase)
                        }
                    }
                    .pickerStyle(.menu)
                    .onChange(of: selectedStatus) { newStatus in
                        appDataStore.updateTaskStatus(for: currentTask, newStatus: newStatus)
                    }
                    .onAppear {
                        selectedStatus = currentTask.status
                    }
                    .padding(.top, 10)
                }
            }
        }
    }

    private var updatesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Divider()
            Text("Updates")
                .font(.title2)
                .fontWeight(.semibold)

            ForEach(currentTask.updates.sorted(by: { $0.timestamp > $1.timestamp }), id: \.id) { update in
                VStack(alignment: .leading) {
                    Text(update.message)
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
    }

    // Helper to get user name if not implemented in AppDataStore
    private func getUserName(for userId: UUID) -> String {
        if userId == User.personA.id {
            return User.personA.name
        } else if userId == User.personB.id {
            return User.personB.name
        }
        return "Unknown User"
    }
}
