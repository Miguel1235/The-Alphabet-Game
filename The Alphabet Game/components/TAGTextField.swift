//
//  TAGTextField.swift
//  The Alphabet Game
//
//  Created by Miguel Del Corso on 10/04/2025.
//

import SwiftUI

struct TAGTextField: View {
    var placeholder: String
    @Binding var text: String
    var body: some View {
        TextField(placeholder, text: $text)
            .multilineTextAlignment(.center)
            .font(.subheadline)
            .controlSize(.large)
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.none)
            .textFieldStyle(.plain)
            .fontWeight(.bold)
            .padding()
            .background(border)
            .padding([.leading, .trailing])
    }
    
    var border: some View {
      RoundedRectangle(cornerRadius: 100)
        .strokeBorder(
          LinearGradient(
            gradient: .init(
              colors: [
                .gray,.brown
              ]
            ),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          ),
          lineWidth: 2
        )
    }
}



#Preview {
    TAGTextField(placeholder: "Input answer", text: .constant(""))
}
