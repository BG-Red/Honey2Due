//
//  CreateQuoteView.swift
//  Honey's 2 Due List
//
//  Created by Zachary Pierce on 6/14/25.
//

import SwiftUI

struct CreateQuoteView: View {
    @EnvironmentObject var appDataStore: AppDataStore
    @Environment(\.dismiss) var dismiss // To dismiss the sheet/navigation after submission

    var task: Task // The task for which the quote is being created/edited
    var isEditing: Bool // A flag to know if we're in "edit existing quote" mode

    @State private var timeframe: String = ""
    @State private var materials: String = ""
    @State private var restrictions: String = ""
    @State private var reward: String = ""
    @State private var showingConfirmationAlert = false // To show an alert after submitting

    var body: some View {
        Form { // Using a Form for structured input fields
            Section("Task: \(task.title)") {
                Text(task.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Section("Your Quote") {
                TextField("Timeframe (e.g., 'This weekend')", text: $timeframe)
                TextField("Materials Needed", text: $materials)
                TextField("Restrictions (e.g., 'After 6 PM')", text: $restrictions)
                TextField("Reward for Completing (e.g., 'Dinner at favorite restaurant')", text: $reward)
            }
            
            Button(isEditing ? "Resubmit Edited Quote" : "Submit Quote") {
                // Ensure all fields are filled before submitting
                if !timeframe.isEmpty && !materials.isEmpty && !restrictions.isEmpty && !reward.isEmpty {
                    if isEditing {
                        // If editing, call the specific function to update the quote
                        appDataStore.rejectAndEditQuote(for: task, newTimeframe: timeframe, newMaterials: materials, newRestrictions: restrictions, newReward: reward)
                    } else {
                        // If creating new, submit a new quote
                        appDataStore.submitQuote(for: task, timeframe: timeframe, materials: materials, restrictions: restrictions, reward: reward)
                    }
                    showingConfirmationAlert = true // Trigger the confirmation alert
                }
            }
            // Disable the button if any required fields are
            .disabled(timeframe.isEmpty || materials.isEmpty || restrictions.isEmpty || reward.isEmpty)
                    .alert("Quote Submitted!", isPresented: $showingConfirmationAlert) {
                        Button("OK", role: .cancel) { dismiss() }
                    } message: {
                        Text(isEditing ? "Your edited quote has been resubmitted for review." : "Your quote has been submitted for review.")
                    }
                } // Closing brace for the Form
            } // Closing brace for the CreateQuoteView struct
