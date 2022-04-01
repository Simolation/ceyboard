//
//  CorrectKeyboardExplanation.swift
//  ceyboard
//
//  Created by Simon Osterlehner on 26.02.22.
//

import SwiftUI

struct CorrectKeyboardExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text("Am I using the correct keyboard?")
                .font(.headline)
            
            Text("You can always recognize the ceyboard keyboard by the small purple dot in the upper left corner.")
                .font(.subheadline)
                .foregroundColor(Color.black)
            
            Image("keyboard_indicator")
                .resizable()
                .scaledToFit()
                .cornerRadius(9)
        }
    }
}

struct CorrectKeyboardExplanation_Previews: PreviewProvider {
    static var previews: some View {
        CorrectKeyboardExplanation()
    }
}
