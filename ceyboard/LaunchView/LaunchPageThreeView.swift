//
//  LaunchPageTwoView.swift
//  demtext
//
//  Created by Constantin Ehmanns on 16.12.21.
//

import SwiftUI
import KeyboardKit
import SwiftUIGIF

struct LaunchPageThreeView: View {
    @EnvironmentObject private var keyboardState: KeyboardEnabledState
    
    var body: some View {
        LaunchPageLayout(currentStep: 3, totalSteps: 4, title: "Set Up the Keyboard", description: "Please enable the keyboard in the system settings. The keyboard also needs Full Access to function properly.", showButton: true, disableButton: false, action: openSettings, button: {
            HStack(alignment: .center, spacing: 5) {
                isKeyboardEnabled ? Text("Grant Full Access"): Text("Enable the keyboard")
                Spacer()
                Image(systemName: "gear")
            }
        }) {
            EnabledItem(
                enabled: isKeyboardEnabled,
                enabledText: Text("Keyboard is enabled"),
                disabledText: Text("Add ") + Text("ceyboard Keyboard").bold() + Text(" to the Keyboard-List")
            )
            EnabledItem(
                enabled: isFullAccessEnabled,
                enabledText: Text("Full Access is enabled"),
                disabledText: Text("Allow ") + Text("Full Access").bold() + Text(" to ceyboard Keyboard")
            )
            
            GIFImage(name: "keyboard_installation") // load from assets
                .frame(height: 400)
        }
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

struct LaunchPageThreeView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchPageThreeView()
    }
}
