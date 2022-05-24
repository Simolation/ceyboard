//
//  KeyboardSelectedHandler.swift
//  ceyboard
//
//  Created by Simon Osterlehner on 20.02.22.
//

import SwiftUI

struct KeyboardSelectedHandler: View {
    
    /**
     View which recognizes that the keyboard has been activated and calls the provided callback
     */
    init(keyboardActive: Bool, onEnable: () -> Void) {
        if keyboardActive {
            onEnable()
        }
    }
    
    var body: some View {
        Spacer()
    }
}

struct KeyboardSelectedHandler_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardSelectedHandler(keyboardActive: false, onEnable: {})
    }
}
