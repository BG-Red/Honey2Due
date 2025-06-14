//
//  TaskUpdate.swift
//  Honey's 2 Due List
//
//  Created by Zachary Pierce on 6/14/25.
//

import Foundation
import SwiftData

@Model
final class TaskUpdate {
    @Attribute(.unique) var id: UUID
    var taskId: UUID
    var userId: UUID // The person who posted the update
    var timestamp: Date
    var message: String
    
    var task: Task? // Inverse relationship

    init(id: UUID = UUID(), taskId: UUID, userId: UUID, timestamp: Date = Date(), message: String) {
        self.id = id
        self.taskId = taskId
        self.userId = userId
        self.timestamp = timestamp
        self.message = message
    }
}
