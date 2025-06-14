//
// Task.swift
// Honey's 2 Due List
//
// Created by Zachary Pierce on 6/14/25.
//

import Foundation

public enum TaskStatus: String, Codable, CaseIterable, Identifiable {
    case pendingQuote = "Pending Quote"
    case quoteSubmitted = "Quote Submitted"
    case quoteReviewed = "Quote Reviewed"
    case approved = "Approved"
    case assigned = "Assigned"
    case inProgress = "In Progress"
    case completed = "Completed"
    case cancelled = "Cancelled"

    public var id: String { self.rawValue } // For Identifiable
}

struct Task: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    let submittedByUserId: UUID
    var assignedToUserId: UUID?
    var status: TaskStatus // This now properly references the enum from Enums.swift
    let createdAt: Date
    var updatedAt: Date
    var updates: [TaskUpdate]
    var currentQuote: Quote?

    init(id: UUID = UUID(), title: String, description: String, submittedByUserId: UUID, assignedToUserId: UUID? = nil, status: TaskStatus = .pendingQuote, createdAt: Date = Date(), updatedAt: Date = Date(), updates: [TaskUpdate] = [], currentQuote: Quote? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.submittedByUserId = submittedByUserId
        self.assignedToUserId = assignedToUserId
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.updates = updates
        self.currentQuote = currentQuote
    }
}
