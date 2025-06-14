//
//  User.swift
//  Honey's 2 Due List
//
//  Created by Zachary Pierce on 6/14/25.
//


import Foundation

struct User: Identifiable, Codable {
    let id: UUID
    let name: String

    // Static properties to represent your two users for simulation
    static let personA = User(id: UUID(uuidString: "A0000000-0000-0000-0000-000000000001")!, name: "Person A")
    static let personB = User(id: UUID(uuidString: "B0000000-0000-0000-0000-000000000002")!, name: "Person B")
}
