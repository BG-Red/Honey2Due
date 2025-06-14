//
//  NewTaskView.swift
//  Honey's 2 Due List
//
//  Created by Zachary Pierce on 6/14/25.
//

import SwiftUI

struct NewTaskView: View {
    @EnvironmentObject var appDataStore: AppDataStore // Access our shared data store
    @State private var title: String = "" // State variable for the task title input
    @State private var description: String = "" // State variable for the task description input

    // MARK: - New @State variables for requested fields
    @State private var requestedStartDate: Date = Date()
    // Default completion date to tomorrow or a few days later
    @State private var completionDate: Date = Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date()
    @State private var priority: Priority = .medium // Default priority
    @State private var requestedReward: String = "" // State variable for the requested reward

    @State private var showingAlert = false // State to control showing a confirmation alert

    var body: some View {
        NavigationView { // Embed in a NavigationView for a title and potential navigation later
            Form { // <--- This line must be exactly 'Form {'
                Section("Task Details") { // A section for general task information
                    TextField("Task Title (e.g., Fix leaky faucet)", text: $title) // Input for the title
                    TextEditor(text: $description) // Multiline input for the description
                        .frame(height: 100) // Give the text editor a fixed height
                        .border(Color.gray.opacity(0.2), width: 1) // Add a subtle border
                        .cornerRadius(5) // Slightly rounded corners for the border

                    // MARK: - Gemini AI Suggestions Button (Placeholder)
                    // As discussed, I cannot implement direct AI integration.
                    // This is a placeholder button for where you would trigger AI suggestions.
                    Button("Get AI Description Suggestions") {
                        // Action to call your AI service for suggestions
                        // For example: fetchSuggestionsFromGeminiAI(for: title)
                        print("AI Suggestion button tapped!")
                    }
                    .buttonStyle(.bordered)
                    .padding(.vertical, 5) // Add some vertical padding for separation
                }

                // MARK: - New Sections for Dates, Priority, and Reward
                Section("Timeline & Priority") {
                    DatePicker("Requested Start Date", selection: $requestedStartDate, displayedComponents: .date)
                    DatePicker("Target Completion Date", selection: $completionDate, in: requestedStartDate..., displayedComponents: .date) // Ensure completion date is after start date

                    Picker("Priority", selection: $priority) {
                        ForEach(Priority.allCases) { p in
                            Text(p.rawValue).tag(p)
                        }
                    }
                    .pickerStyle(.segmented) // A compact way to select priority
                }

                Section("Reward") {
                    TextField("Requested Reward (e.g., 'Dinner at favorite restaurant')", text: $requestedReward)
                }

                Button("Submit Task") { // The button to submit the new task
                    // Ensure required fields are not empty before submission
                    if !title.isEmpty && !description.isEmpty {
                        appDataStore.submitTask(
                            title: title,
                            description: description,
                            requestedStartDate: requestedStartDate,
                            completionDate: completionDate,
                            priority: priority,
                            requestedReward: requestedReward.isEmpty ? nil : requestedReward // Pass nil if empty
                        ) // Call the data store function with new parameters
                        title = "" // Clear the title field after submission
                        description = "" // Clear the description field after submission
                        requestedReward = "" // Clear reward field
                        requestedStartDate = Date() // Reset dates and priority to defaults
                        completionDate = Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date()
                        priority = .medium
                        showingAlert = true // Show the confirmation alert
                    }
                }
                .disabled(title.isEmpty || description.isEmpty) // Disable button if title/description are empty
            }
            .navigationTitle("New Honey-Do") // Title for this view
            .alert("Task Submitted!", isPresented: $showingAlert) { // Confirmation alert
                Button("OK", role: .cancel) { } // Simple OK button
            } message: {
                Text("Your task has been sent for a quote.") // Message in the alert
            }
        }
    }
}

// MARK: - Preview
#Preview {
    NewTaskView()
        .environmentObject(AppDataStore()) // Provide a dummy AppDataStore for the preview
}
