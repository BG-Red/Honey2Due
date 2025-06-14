//
//  CreateQuoteView.swift
//  Honey's 2 Due List
//
//  Created by Zachary Pierce on 6/14/25.
//

import SwiftUI
import SwiftData

struct CreateQuoteView: View {
    @EnvironmentObject var appDataStore: AppDataStore
    @Environment(\.dismiss) var dismiss

    @Bindable var task: Task

    @State private var showingConfirmationAlert = false

    // MARK: - Custom Bindings
    // This is the correct pattern. We create a custom, non-optional binding
    // for each property. Inside the get/set, we can safely use '!' because
    // our onAppear logic guarantees the quote object exists.
    
    private var timeframeBinding: Binding<String> {
        Binding(
            get: { self.task.currentQuote!.timeframe },
            set: { self.task.currentQuote!.timeframe = $0 }
        )
    }
    
    private var materialsBinding: Binding<String> {
        Binding(
            get: { self.task.currentQuote!.materials },
            set: { self.task.currentQuote!.materials = $0 }
        )
    }
    
    private var restrictionsBinding: Binding<String> {
        Binding(
            get: { self.task.currentQuote!.restrictions },
            set: { self.task.currentQuote!.restrictions = $0 }
        )
    }
    
    private var rewardBinding: Binding<String> {
        Binding(
            get: { self.task.currentQuote!.reward },
            set: { self.task.currentQuote!.reward = $0 }
        )
    }

    var body: some View {
        Form {
            Section("Task: \(task.title)") {
                Text(task.details)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 5)

                if let startDate = task.requestedStartDate {
                    QuoteDetailRow(label: "Requested Start", value: startDate.formatted(date: .numeric, time: .omitted))
                }
                if let completionDate = task.completionDate {
                    QuoteDetailRow(label: "Target Completion", value: completionDate.formatted(date: .numeric, time: .omitted))
                }
                QuoteDetailRow(label: "Priority", value: task.priority.rawValue)

                if let requestedReward = task.requestedReward, !requestedReward.isEmpty {
                    QuoteDetailRow(label: "Requested Reward", value: requestedReward)
                }
            }

            // This 'if' adds a layer of safety before showing the section
            if task.currentQuote != nil {
                Section("Your Quote") {
                    // Use the custom bindings we created above
                    TextField("Timeframe (e.g., 'This weekend')", text: timeframeBinding)
                    TextField("Materials Needed", text: materialsBinding)
                    TextField("Restrictions (e.g., 'After 6 PM')", text: restrictionsBinding)
                    TextField("Reward for Completing", text: rewardBinding)
                }
            }

            Button(isEditing ? "Resubmit Edited Quote" : "Submit Quote") {
                submitOrUpdateQuote()
                showingConfirmationAlert = true
            }
            .disabled(task.currentQuote?.timeframe.isEmpty ?? true || task.currentQuote?.reward.isEmpty ?? true)
            .alert("Quote Submitted!", isPresented: $showingConfirmationAlert) {
                Button("OK", role: .cancel) { dismiss() }
            } message: {
                Text("Your quote has been submitted for review.")
            }
        }
        .onAppear(perform: setupQuote)
    }

    private var isEditing: Bool {
        guard let status = task.currentQuote?.status else { return false }
        return status == .pendingReview || status == .editedAndResubmitted
    }

    private func setupQuote() {
        if task.currentQuote == nil {
            task.currentQuote = Quote(
                taskId: task.id,
                submittedByUserId: appDataStore.currentUser.id,
                timeframe: "",
                materials: "",
                restrictions: "",
                reward: ""
            )
        }
    }

    private func submitOrUpdateQuote() {
        guard let quote = task.currentQuote else { return }

        if quote.status != .editedAndResubmitted {
            quote.status = .pendingReview
        }
        
        quote.updatedAt = Date()
        task.status = .quoteSubmitted
        task.updatedAt = Date()
    }
}
