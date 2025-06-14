//
// Task.swift
// Honey's 2 Due List
//
// Created by Zachary Pierce on 6/14/25.
//

import Foundation
import SwiftData

@Model
final class Task {
    @Attribute(.unique) var id: UUID
    var title: String
    var details: String // Renamed from 'description'
    var submittedByUserId: UUID
    var assignedToUserId: UUID?
    var status: TaskStatus
    var createdAt: Date
    var updatedAt: Date
    
    // New properties for the task request:
    var requestedStartDate: Date?
    var completionDate: Date?
    var priority: Priority
    var requestedReward: String?

    @Relationship(deleteRule: .cascade, inverse: \TaskUpdate.task)
    var updates: [TaskUpdate] = []
    
    @Relationship(deleteRule: .cascade, inverse: \Quote.task)
    var currentQuote: Quote?
    
    init(id: UUID = UUID(),
         title: String,
         details: String, // Renamed from 'description'
         submittedByUserId: UUID,
         assignedToUserId: UUID? = nil,
         status: TaskStatus = .pendingQuote,
         createdAt: Date = Date(),
         updatedAt: Date = Date(),
         requestedStartDate: Date? = nil,
         completionDate: Date? = nil,
         priority: Priority = .medium,
         requestedReward: String? = nil
    ) {
        self.id = id
        self.title = title
        self.details = details // Renamed from 'description'
        self.submittedByUserId = submittedByUserId
        self.assignedToUserId = assignedToUserId
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.requestedStartDate = requestedStartDate
        self.completionDate = completionDate
        self.priority = priority
        self.requestedReward = requestedReward
    }
}
