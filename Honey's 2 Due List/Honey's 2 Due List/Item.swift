//
//  Item.swift
//  Honey's 2 Due List
//
//  Created by Zachary Pierce on 6/14/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
