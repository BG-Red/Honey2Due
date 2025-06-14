//
//  QuoteDetailRow.swift
//  Honey's 2 Due List
//
//  Created by Zachary Pierce on 6/14/25.

import SwiftUI

struct QuoteDetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
    }
}

// MARK: - Preview
#Preview {
    QuoteDetailRow(label: "Test Label", value: "Test Value")
        .padding()
}
