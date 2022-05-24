//
//  LaunchPageFourView.swift
//  ceyboard
//
//  Created by Simon Osterlehner on 20.02.22.
//

import SwiftUI
import KeyboardKit

struct LaunchPageFourView: View {
    @EnvironmentObject private var keyboardState: KeyboardEnabledState
    @AppStorage("onboarding.keyboard.selected") var onboardingKeyboardSelected = false
    
    @State private var value = ""
    
    var body: some View {
        LaunchPageLayout(currentStep: 4, totalSteps: 4, title: "Switch the keybord", description: "Tab and hold the 🌐 to select ceyboard Keyboard below.", showButton: false, disableButton: false, action: {}, button: {
            Spacer()
        }) {
            HStack {
                Button(action: activateKeyboard) {
                    Text("Skip keyboard switching").font(.caption)
                }
                Spacer()
            }
            CorrectKeyboardExplanation()
            
            // Force open the keyboard
            OpenKeyboard()
            
            // This will set the keyboard as selected
            KeyboardSelectedHandler(keyboardActive: keyboardState.isKeyboardCurrentlyActive, onEnable: activateKeyboard)
        }
    }
    
    func activateKeyboard() {
        if !onboardingKeyboardSelected {
            onboardingKeyboardSelected.toggle()
        }
    }
}

struct LaunchPageFourView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchPageFourView()
    }
}
