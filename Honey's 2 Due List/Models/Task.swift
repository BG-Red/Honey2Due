//
// Task.swift
// Honey's 2 Due List
//
// Created by Zachary Pierce on 6/14/25.
//

import Foundation

// Note: TaskStatus enum is now typically in Enums.swift
// Make sure TaskStatus and Priority are accessible (e.g., from Enums.swift if you've put them there)

struct Task: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    let submittedByUserId: UUID
    var assignedToUserId: UUID?
    var status: TaskStatus
    let createdAt: Date
    var updatedAt: Date
    var updates: [TaskUpdate]
    var currentQuote: Quote?

    // New properties for the task request:
    var requestedStartDate: Date? // <--- NEW
    var completionDate: Date?     // <--- NEW
    var priority: Priority      // <--- NEW
    var requestedReward: String?  // <--- NEW - Added as optional string for initial request

    init(id: UUID = UUID(),
         title: String,
         description: String,
         submittedByUserId: UUID,
         assignedToUserId: UUID? = nil,
         status: TaskStatus = .pendingQuote,
         createdAt: Date = Date(),
         updatedAt: Date = Date(),
         updates: [TaskUpdate] = [],
         currentQuote: Quote? = nil,
         requestedStartDate: Date? = nil, // <--- NEW in init
         completionDate: Date? = nil,     // <--- NEW in init
         priority: Priority = .medium,    // <--- NEW in init, with a default
         requestedReward: String? = nil   // <--- NEW in init
    ) {
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
        self.requestedStartDate = requestedStartDate // <--- Assign new properties
        self.completionDate = completionDate
        self.priority = priority
        self.requestedReward = requestedReward
    }
}

