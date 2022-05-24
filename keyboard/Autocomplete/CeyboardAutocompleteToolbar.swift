//
//  CeyboardAutocompleteToolbar.swift
//  keyboard
//
//  Created by Constantin Ehmanns on 11.11.21.
//  Inspired by: https://github.com/KeyboardKit/KeyboardKit/blob/master/Demo/Keyboard/Autocomplete/DemoAutocompleteToolbar.swift

import Foundation
import SwiftUI
import KeyboardKit

/**
 Customized Autocomplete Toolbar which adds a small purple dot to the left side
 */
struct CeyboardAutocompleteToolbar: View {
    
    @EnvironmentObject private var context: AutocompleteContext
    @EnvironmentObject private var keyboardContext: KeyboardContext
    
    var body: some View {
        HStack(alignment: .center) {
            // Add keyboard indicator
            Circle()
                .fill(Color("AccentColor"))
                .frame(width: 7, height: 7)
                .padding(EdgeInsets(top: 0, leading: 9, bottom: 0, trailing: 0))
            
            // instead of AutocompleteToolbar
            CustomAutocompleteToolbar(
                suggestions: context.suggestions,
                locale: keyboardContext.locale)
            .frame(height: 50)
            Spacer()
        }
    }
}

struct DemoAutocompleteToolbar_Previews: PreviewProvider {
    static var previews: some View {
        CeyboardAutocompleteToolbar()
    }
}
