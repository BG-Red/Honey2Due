//
//  TaskUpdate.swift
//  Honey's 2 Due List
//
//  Created by Zachary Pierce on 6/14/25.
//

import Foundation

struct TaskUpdate: Identifiable, Codable {
    let id: UUID
    let taskId: UUID
    let userId: UUID // The person who posted the update
    let timestamp: Date
    var message: String

    init(id: UUID = UUID(), taskId: UUID, userId: UUID, timestamp: Date = Date(), message: String) {
        self.id = id
        self.taskId = taskId
        self.userId = userId
        self.timestamp = timestamp
        self.message = message
    }
}

