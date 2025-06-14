//import Foundation
import Combine

class AppDataStore: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var currentUser: User // Represents the currently logged-in user

    init() {
        // Initialize with a default user for testing
        // In a real app, this would be set after login.
        self.currentUser = .personA // Start as Person A for submission
        loadSampleData()
    }

    // MARK: - User Management (Simplified for this example)
    func switchUser(to user: User) {
        currentUser = user
        print("Switched to user: \(user.name)")
        // In a real app, this would involve logging out and logging in.
    }

    // MARK: - Task Operations

    func submitTask(title: String, description: String) {
        let newTask = Task(title: title, description: description, submittedByUserId: currentUser.id)
        tasks.append(newTask)
        print("Task submitted by \(currentUser.name): \(newTask.title)")
        // In real app: Send to backend, notify Person B
    }

    func submitQuote(for task: Task, timeframe: String, materials: String, restrictions: String, reward: String) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }

        let newQuote = Quote(taskId: task.id, submittedByUserId: currentUser.id, timeframe: timeframe, materials: materials, restrictions: restrictions, reward: reward, status: .pendingReview)

        tasks[index].currentQuote = newQuote
        tasks[index].status = .quoteSubmitted
        tasks[index].updatedAt = Date()
        print("Quote submitted by \(currentUser.name) for task: \(task.title)")
        // In real app: Send to backend, notify Person A
    }

    func approveQuote(for task: Task) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }),
              var currentQuote = tasks[index].currentQuote else { return }

        currentQuote.status = .approved
        currentQuote.updatedAt = Date()
        tasks[index].currentQuote = currentQuote
        tasks[index].status = .approved // Finalized status for task
        tasks[index].assignedToUserId = currentQuote.submittedByUserId // Assign to the person who quoted
        tasks[index].updatedAt = Date()
        print("Quote approved by \(currentUser.name) for task: \(task.title). Task assigned to \(currentQuote.submittedByUserId)")
        // In real app: Send to backend, notify Person B
    }

    func rejectAndEditQuote(for task: Task, newTimeframe: String, newMaterials: String, newRestrictions: String, newReward: String) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }),
              var currentQuote = tasks[index].currentQuote else { return }

        // Create a new quote with edited details (or modify existing, depends on desired history)
        // For simplicity, let's modify the existing one and mark it as re-submitted
        currentQuote.timeframe = newTimeframe
        currentQuote.materials = newMaterials
        currentQuote.restrictions = newRestrictions
        currentQuote.reward = newReward
        currentQuote.status = .editedAndResubmitted // Indicate it's back for approval
        currentQuote.updatedAt = Date()

        tasks[index].currentQuote = currentQuote
        tasks[index].status = .quoteSubmitted // Go back to quote submitted state
        tasks[index].updatedAt = Date()
        print("Quote edited and resubmitted by \(currentUser.name) for task: \(task.title)")
        // In real app: Send to backend, notify Person B
    }

    func addUpdate(to task: Task, message: String) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }

        let newUpdate = TaskUpdate(taskId: task.id, userId: currentUser.id, message: message)
        tasks[index].updates.append(newUpdate)
        tasks[index].updatedAt = Date()
        print("Update added by \(currentUser.name) for task \(task.title): \(message)")
        // In real app: Send to backend, notify the other user
    }

    // MARK: - Sample Data for Testing

    private func loadSampleData() {
        let task1 = Task(title: "Fix leaky faucet", description: "The kitchen faucet has a slow drip. Need to replace the washer.", submittedByUserId: .personA.id)
        var task2 = Task(title: "Organize garage", description: "It's a disaster! Everything needs a place.", submittedByUserId: .personA.id)
        var quote2 = Quote(taskId: task2.id, submittedByUserId: .personB.id, timeframe: "This weekend (Saturday afternoon)", materials: "Storage bins, labels", restrictions: "Must be done before dinner", reward: "Your favorite homemade cookies!")
        task2.currentQuote = quote2
        task2.status = .quoteSubmitted

        var task3 = Task(title: "Build new shelf for plants", description: "Need a small shelf for the living room plants, similar to the one we saw at IKEA.", submittedByUserId: .personB.id)
        var quote3 = Quote(taskId: task3.id, submittedByUserId: .personA.id, timeframe: "Next 2 weeks", materials: "Wood, screws, drill, paint", restrictions: "Only when kids are asleep", reward: "A day of no chores!")
        quote3.status = .approved // Simulating an already approved quote
        task3.currentQuote = quote3
        task3.status = .approved
        task3.assignedToUserId = .personA.id // Assigned to Person A who quoted it

        tasks = [task1, task2, task3]

        // Add some updates to task3
        addUpdate(to: tasks[2], message: "Bought the wood today!")
        addUpdate(to: tasks[2], message: "Started cutting pieces, almost done.")
        addUpdate(to: tasks[2], message: "Need to get some specific screws tomorrow.")
    }
}
//  AppDataStore.swift
//  Honey's 2 Due List
//
//  Created by Zachary Pierce on 6/14/25.
//

