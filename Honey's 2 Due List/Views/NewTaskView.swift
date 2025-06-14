//
//  NewTaskView.swift
//  Honey's 2 Due List
//
//  Created by Zachary Pierce on 6/14/25.
//

import SwiftUI

struct NewTaskView: View {
    @EnvironmentObject var appDataStore: AppDataStore

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var requestedStartDate: Date = Date()
    @State private var completionDate: Date = Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date()
    @State private var priority: Priority = .medium
    @State private var requestedReward: String = ""
    @State private var showingAlert = false

    var body: some View {
        NavigationView {
            Form {
                // MARK: Task Details Section
                Section(header: Text("Task Details")) {
                    TextField("Task Title (e.g., Fix leaky faucet)", text: $title)

                    TextEditor(text: $description)
                        .frame(height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )

                    Button("Get AI Description Suggestions") {
                        print("AI Suggestion button tapped!")
                    }
                    .buttonStyle(.bordered)
                    .padding(.vertical, 5)
                }

                // MARK: Timeline & Priority Section
                Section(header: Text("Timeline & Priority")) {
                    DatePicker("Requested Start Date", selection: $requestedStartDate, displayedComponents: .date)

                    DatePicker("Target Completion Date", selection: $completionDate, in: requestedStartDate..., displayedComponents: .date)

                    Picker("Priority", selection: $priority) {
                        ForEach(Priority.allCases, id: \.self) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                // MARK: Reward Section
                Section(header: Text("Reward")) {
                    TextField("Requested Reward (e.g., 'Dinner at favorite restaurant')", text: $requestedReward)
                }

                // MARK: Submit Button
                Section {
                    Button("Submit Task") {
                        submitTask()
                    }
                    .disabled(title.isEmpty || description.isEmpty)
                }
            }
            .navigationTitle("New Honey-Do")
            .alert("Task Submitted!", isPresented: $showingAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Your task has been sent for a quote.")
            }
        }
    }

    private func submitTask() {
        appDataStore.submitTask(
            title: title,
            description: description,
            requestedStartDate: requestedStartDate,
            completionDate: completionDate,
            priority: priority,
            requestedReward: requestedReward.isEmpty ? nil : requestedReward
        )

        // Reset fields
        title = ""
        description = ""
        requestedReward = ""
        requestedStartDate = Date()
        completionDate = Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date()
        priority = .medium
        showingAlert = true
    }
}

#Preview {
    NewTaskView()
        .environmentObject(AppDataStore())
}
