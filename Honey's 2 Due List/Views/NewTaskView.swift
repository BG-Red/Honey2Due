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
    @State private var showingAlert = false // State to control showing a confirmation alert

    var body: some View {
        NavigationView { // Embed in a NavigationView for a title and potential navigation later
            Form { // Use a Form for nicely organized input fields
                Section("Task Details") { // A section for general task information
                    TextField("Task Title (e.g., Fix leaky faucet)", text: $title) // Input for the title
                    TextEditor(text: $description) // Multiline input for the description
                        .frame(height: 100) // Give the text editor a fixed height
                        .border(Color.gray.opacity(0.2), width: 1) // Add a subtle border
                        .cornerRadius(5) // Slightly rounded corners for the border
                }

                Button("Submit Task") { // The button to submit the new task
                    if !title.isEmpty && !description.isEmpty { // Ensure fields are not empty
                        appDataStore.submitTask(title: title, description: description) // Call the data store function
                        title = "" // Clear the title field after submission
                        description = "" // Clear the description field after submission
                        showingAlert = true // Show the confirmation alert
                    }
                }
                .disabled(title.isEmpty || description.isEmpty) // Disable button if fields are empty
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
