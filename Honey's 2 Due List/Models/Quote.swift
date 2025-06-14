//
// Quote.swift
// Honey's 2 Due List
//
// Created by Zachary Pierce on 6/14/25.
//

import Foundation
import SwiftData

@Model
final class Quote {
    @Attribute(.unique) var id: UUID
    var taskId: UUID
    var submittedByUserId: UUID
    var timeframe: String
    var materials: String
    var restrictions: String
    var reward: String
    var status: QuoteStatus
    var createdAt: Date
    var updatedAt: Date

    var task: Task? // Inverse relationship

    init(id: UUID = UUID(), taskId: UUID, submittedByUserId: UUID, timeframe: String, materials: String, restrictions: String, reward: String, status: QuoteStatus = .pendingReview, createdAt: Date = Date(), updatedAt: Date = Date()) {
        self.id = id
        self.taskId = taskId
        self.submittedByUserId = submittedByUserId
        self.timeframe = timeframe
        self.materials = materials
        self.restrictions = restrictions
        self.reward = reward
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
