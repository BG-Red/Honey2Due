//
// Quote.swift
// Honey's 2 Due List
//
// Created by Zachary Pierce on 6/14/25.
//

import Foundation

enum QuoteStatus: String, Codable, CaseIterable, Identifiable {
    case pendingReview = "Pending Review"
    case approved = "Approved"
    case rejected = "Rejected"
    case editedAndResubmitted = "Edited & Resubmitted"

    var id: String { self.rawValue }
}

struct Quote: Identifiable, Codable {
    let id: UUID
    let taskId: UUID
    let submittedByUserId: UUID
    var timeframe: String
    var materials: String
    var restrictions: String
    var reward: String
    var status: QuoteStatus
    let createdAt: Date
    var updatedAt: Date

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

    // Explicit Codable conformance
    enum CodingKeys: String, CodingKey {
        case id
        case taskId
        case submittedByUserId
        case timeframe
        case materials
        case restrictions
        case reward
        case status
        case createdAt
        case updatedAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        taskId = try container.decode(UUID.self, forKey: .taskId)
        submittedByUserId = try container.decode(UUID.self, forKey: .submittedByUserId)
        timeframe = try container.decode(String.self, forKey: .timeframe)
        materials = try container.decode(String.self, forKey: .materials)
        restrictions = try container.decode(String.self, forKey: .restrictions)
        reward = try container.decode(String.self, forKey: .reward)
        status = try container.decode(QuoteStatus.self, forKey: .status)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        updatedAt = try container.decode(Date.self, forKey: .updatedAt)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(taskId, forKey: .taskId)
        try container.encode(submittedByUserId, forKey: .submittedByUserId)
        try container.encode(timeframe, forKey: .timeframe)
        try container.encode(materials, forKey: .materials)
        try container.encode(restrictions, forKey: .restrictions)
        try container.encode(reward, forKey: .reward)
        try container.encode(status, forKey: .status)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
    }
}
