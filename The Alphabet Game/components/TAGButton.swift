//
//  TAGButton.swift
//  The Alphabet Game
//
//  Created by Miguel Del Corso on 10/04/2025.
//

import SwiftUI

struct TAGButton: View {
    var text: String
    var icon: String
    var action: (() -> Void)
    var body: some View {
        Button(action: action) {
            Label(text, systemImage: icon)
                .font(.title2)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.extraLarge)
    }
}


#Preview {
    TAGButton(text: "Search", icon: "target", action: {})
}
