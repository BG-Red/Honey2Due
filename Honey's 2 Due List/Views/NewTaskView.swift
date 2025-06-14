//
//  NewTaskView.swift
//  Honey's 2 Due List
//
//  Created by Zachary Pierce on 6/14/25.
//

import SwiftUI
import SwiftData

struct NewTaskView: View {
    @EnvironmentObject var appDataStore: AppDataStore
    @Environment(\.modelContext) private var modelContext

    @State private var title: String = ""
    @State private var details: String = "" // Renamed from 'description'
    @State private var requestedStartDate: Date = Date()
    // ... other @State properties

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Task Title (e.g., Fix leaky faucet)", text: $title)
                    TextEditor(text: $details) // Renamed from 'description'
                        .frame(height: 100)
                    // ...
                }
                // ... other sections
                Section {
                    Button("Submit Task") {
                        submitTask()
                    }
                    .disabled(title.isEmpty || details.isEmpty) // Renamed from 'description'
                }
            }
            // ...
        }
    }

    private func submitTask() {
        let newTask = Task(
            title: title,
            details: details, // Renamed from 'description'
            submittedByUserId: appDataStore.currentUser.id,
            requestedStartDate: requestedStartDate,
            // ... other parameters
        )
        
        modelContext.insert(newTask)

        // Reset fields
        title = ""
        details = "" // Renamed from 'description'
        // ... reset other fields
    }
}
