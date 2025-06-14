//
//  TaskDetailView.swift
//  Honey's 2 Due List
//
//  Created by Zachary Pierce on 6/14/25.
//

import SwiftUI
import SwiftData

struct TaskDetailView: View {
    @EnvironmentObject var appDataStore: AppDataStore
    @Environment(\.modelContext) private var modelContext
    
    @Bindable var task: Task

    @State private var updateMessage: String = ""
    @State private var showingEditQuoteSheet = false

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
            CreateQuoteView(task: task)
        }
    }

    // MARK: - Subviews

    private var taskInfoSection: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(task.title)
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("Status: \(task.status.rawValue)")
                .font(.headline)
            Text("Submitted by: \(appDataStore.getUserName(for: task.submittedByUserId))")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("Description:")
                .font(.headline)
                .padding(.top, 5)
            Text(task.details)
                .font(.body)

            if let startDate = task.requestedStartDate {
                Text("Requested Start: \(startDate.formatted(date: .numeric, time: .omitted))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            if let completionDate = task.completionDate {
                Text("Target Completion: \(completionDate.formatted(date: .numeric, time: .omitted))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Text("Priority: \(task.priority.rawValue)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            if let requestedReward = task.requestedReward, !requestedReward.isEmpty {
                Text("Requested Reward: \(requestedReward)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }

    @ViewBuilder
    private var quoteSection: some View {
        if let quote = task.currentQuote {
            Divider()
            VStack(alignment: .leading, spacing: 10) {
                Text("Current Quote")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.bottom, 5)

                QuoteDetailRow(label: "Timeframe", value: quote.timeframe)
                QuoteDetailRow(label: "Materials", value: quote.materials)
                QuoteDetailRow(label: "Restrictions", value: quote.restrictions)
                QuoteDetailRow(label: "Reward", value: quote.reward)
                QuoteDetailRow(label: "Quote Status", value: quote.status.rawValue)

                Divider().padding(.vertical, 5)

                if task.submittedByUserId == appDataStore.currentUser.id && task.status == .quoteSubmitted {
                    HStack {
                        Button("Approve Quote") { approveQuote() }
                            .buttonStyle(.borderedProminent).tint(.green)
                        Button("Edit Quote") { showingEditQuoteSheet = true }
                            .buttonStyle(.bordered)
                    }
                    .padding(.top, 10)
                } else if task.assignedToUserId == appDataStore.currentUser.id &&
                            task.status != .completed && task.status != .cancelled {
                    Picker("Update Task Status", selection: $task.status) {
                        ForEach(TaskStatus.allCases.filter {
                            ![.pendingQuote, .quoteSubmitted, .quoteReviewed, .approved, .cancelled].contains($0)
                        }) { statusCase in
                            Text(statusCase.rawValue).tag(statusCase)
                        }
                    }
                    .pickerStyle(.menu)
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

            ForEach(task.updates.sorted(by: { $0.timestamp > $1.timestamp })) { update in
                VStack(alignment: .leading) {
                    Text(update.message).font(.body)
                    Text("– \(appDataStore.getUserName(for: update.userId)) on \(update.timestamp.formatted(date: .numeric, time: .shortened))")
                        .font(.caption).foregroundColor(.secondary)
                }
                .padding(.bottom, 5)
            }

            TextField("Add a new update...", text: $updateMessage)
                .textFieldStyle(.roundedBorder)

            Button("Post Update") { postUpdate() }
                .buttonStyle(.borderedProminent)
                .disabled(updateMessage.isEmpty)
        }
    }
    
    // MARK: - Data Functions
    
    private func approveQuote() {
        guard let quote = task.currentQuote else { return }
        quote.status = .approved
        quote.updatedAt = Date()
        
        task.status = .approved
        task.assignedToUserId = quote.submittedByUserId
        task.updatedAt = Date()
    }
    
    private func postUpdate() {
        if !updateMessage.isEmpty {
            let newUpdate = TaskUpdate(
                taskId: task.id,
                userId: appDataStore.currentUser.id,
                message: updateMessage
            )
            task.updates.append(newUpdate)
            updateMessage = ""
        }
    }
}
