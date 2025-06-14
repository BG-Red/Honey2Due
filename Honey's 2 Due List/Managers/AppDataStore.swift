//
//  AppDataStore.swift
//  Honey's 2 Due List
//
//  Created by Zachary Pierce on 6/14/25.
//

import Foundation
import Combine

class AppDataStore: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var currentUser: User // Represents the currently logged-in user

    init() {
        // Initialize with a default user for testing
        self.currentUser = .personA
        //loadSampleData()
    }

    // MARK: - User Management

    func switchUser(to user: User) {
        currentUser = user
        print("Switched to user: \(user.name)")
    }

    // MARK: - Task Operations

    func submitTask(
        title: String,
        description: String,
        requestedStartDate: Date,
        completionDate: Date,
        priority: Priority,
        requestedReward: String?
    ) {
        let newTask = Task(
            title: title,
            description: description,
            submittedByUserId: currentUser.id,
            requestedStartDate: requestedStartDate,
            completionDate: completionDate,
            priority: priority,
            requestedReward: requestedReward
        )

        tasks.append(newTask)
        print("Task submitted by \(currentUser.name): \(newTask.title)")
    }

    func submitQuote(for task: Task, timeframe: String, materials: String, restrictions: String, reward: String) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }

        let newQuote = Quote(
            taskId: task.id,
            submittedByUserId: currentUser.id,
            timeframe: timeframe,
            materials: materials,
            restrictions: restrictions,
            reward: reward,
            status: .pendingReview
        )

        tasks[index].currentQuote = newQuote
        tasks[index].status = .quoteSubmitted
        tasks[index].updatedAt = Date()
        print("Quote submitted by \(currentUser.name) for task: \(task.title)")
    }

    func approveQuote(for task: Task) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }),
              var currentQuote = tasks[index].currentQuote else { return }

        currentQuote.status = .approved
        currentQuote.updatedAt = Date()
        tasks[index].currentQuote = currentQuote
        tasks[index].status = .approved
        tasks[index].assignedToUserId = currentQuote.submittedByUserId
        tasks[index].updatedAt = Date()
        print("Quote approved by \(currentUser.name) for task: \(task.title). Assigned to \(currentQuote.submittedByUserId)")
    }

    func rejectAndEditQuote(for task: Task, newTimeframe: String, newMaterials: String, newRestrictions: String, newReward: String) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }),
              var currentQuote = tasks[index].currentQuote else { return }

        currentQuote.timeframe = newTimeframe
        currentQuote.materials = newMaterials
        currentQuote.restrictions = newRestrictions
        currentQuote.reward = newReward
        currentQuote.status = .editedAndResubmitted
        currentQuote.updatedAt = Date()

        tasks[index].currentQuote = currentQuote
        tasks[index].status = .quoteSubmitted
        tasks[index].updatedAt = Date()
        print("Quote edited and resubmitted by \(currentUser.name) for task: \(task.title)")
    }

    func addUpdate(to task: Task, message: String) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }

        let newUpdate = TaskUpdate(taskId: task.id, userId: currentUser.id, message: message)
        tasks[index].updates.append(newUpdate)
        tasks[index].updatedAt = Date()
        print("Update added by \(currentUser.name) for task \(task.title): \(message)")
    }

    // Optional: Sample Data for Testing
    /*
    private func loadSampleData() {
        let task1 = Task(
            title: "Fix leaky faucet",
            description: "The kitchen faucet has a slow drip.",
            submittedByUserId: .personA.id
        )

        var task2 = Task(
            title: "Organize garage",
            description: "It's a disaster!",
            submittedByUserId: .personA.id
        )

        var quote2 = Quote(
            taskId: task2.id,
            submittedByUserId: .personB.id,
            timeframe: "This weekend",
            materials: "Storage bins, labels",
            restrictions: "Must be done before dinner",
            reward: "Homemade cookies!"
        )

        task2.currentQuote = quote2
        task2.status = .quoteSubmitted

        tasks = [task1, task2]
    }
    */
}
