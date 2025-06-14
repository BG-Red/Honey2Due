//
//  AppDataStore.swift
//  Honey's 2 Due List
//
//  Created by Zachary Pierce on 6/14/25.
//

import Foundation
import Combine

class AppDataStore: ObservableObject {
    @Published var currentUser: User // Represents the currently logged-in user

    init() {
        // Initialize with a default user for testing
        self.currentUser = .personA
    }

    // MARK: - User Management

    func switchUser(to user: User) {
        currentUser = user
        print("Switched to user: \(user.name)")
    }

    // Helper to get user name
    func getUserName(for userId: UUID) -> String {
        if userId == User.personA.id {
            return User.personA.name
        } else if userId == User.personB.id {
            return User.personB.name
        }
        return "Unknown User"
    }
}
