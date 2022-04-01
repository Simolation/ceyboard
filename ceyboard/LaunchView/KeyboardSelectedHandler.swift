//
//  KeyboardSelectedHandler.swift
//  demtext
//
//  Created by Simon Osterlehner on 20.02.22.
//

import SwiftUI

struct KeyboardSelectedHandler: View {
    
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
