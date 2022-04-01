//
//  KeyboardEnableOptions.swift
//  demtext
//
//  Created by Simon Osterlehner on 20.02.22.
//

import SwiftUI
import KeyboardKit

struct KeyboardEnableOptions: View {
    
    @EnvironmentObject private var keyboardState: KeyboardEnabledState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            EnabledItem(
                enabled: isKeyboardEnabled,
                enabledText: Text("Keyboard is enabled"),
                disabledText: Text("Add ") + Text("Demtext Keyboard").bold() + Text(" to the Keyboard-List"))
            EnabledItem(
                enabled: isFullAccessEnabled,
                enabledText: Text("Full Access is enabled"),
                disabledText: Text("Allow ") + Text("Full Access").bold() + Text(" to Demtext Keyboard"))
            VStack(alignment: .leading) {
                Divider()
                Button(action: openSettings) {
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "gear")
                        Text("Open Settings")
                        Spacer()
                        Image(systemName: "chevron.right").foregroundColor(.gray.opacity(0.5))
                    }
                }.padding(EdgeInsets(top: 9, leading: 0, bottom: 0, trailing: 0))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(9)
    }
    
    var isKeyboardEnabled: Bool {
        keyboardState.isKeyboardEnabled
    }
    
    var isFullAccessEnabled: Bool {
        keyboardState.isFullAccessEnabled
    }
    
    var allEnabled: Bool {
        isKeyboardEnabled && isFullAccessEnabled
    }
    
    func openSettings() {
        guard let url = URL.keyboardSettings else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

struct KeyboardEnableOptions_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardEnableOptions()
    }
}
