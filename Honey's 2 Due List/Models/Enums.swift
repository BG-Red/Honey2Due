//
// Enums.swift
// Honey's 2 Due List
//
// Created by Zachary Pierce on 6/14/25.
//

import Foundation

// MARK: - Enums

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

public enum QuoteStatus: String, Codable, CaseIterable, Identifiable {
    case pendingReview = "Pending Review"
    case approved = "Approved"
    case rejected = "Rejected"
    case editedAndResubmitted = "Edited & Resubmitted"

    public var id: String { self.rawValue } // For Identifiable
}

public enum Priority: String, Codable, CaseIterable, Identifiable { // <--- Add this new enum
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case urgent = "Urgent"

    public var id: String { self.rawValue }
}
