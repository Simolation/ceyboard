//
//  ContentView.swift
//  ceyboard
//
//  Created by Simon Osterlehner on 03.11.21.
//

import SwiftUI
import CoreData
import KeyboardKit
import Combine

struct ContentView: View {
    @EnvironmentObject private var keyboardState: KeyboardEnabledState
    
    @AppStorage("onboarding.landing") var onboardingLanding = false
    @AppStorage("onboarding.profile") var onboardingProfile = false
    @AppStorage("onboarding.keyboard.selected") var onboardingKeyboardSelected = false
    
    @State private var tabSelection = 1
    
    let appearance: UITabBarAppearance = UITabBarAppearance()
    init() {
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            // Show the different onboarding steps
            if !onboardingLanding {
                LaunchPageOneView(nextPage: {
                    onboardingLanding.toggle()
                })
            } else if !onboardingProfile {
                LaunchPageTwoView(nextPage: {
                    onboardingProfile.toggle()
                })
            } else if !keyboardEnabled {
                LaunchPageThreeView()
            } else if !onboardingKeyboardSelected {
                LaunchPageFourView()
            } else {
                // Show main content as a tab view
                TabView(selection: $tabSelection) {
                    // Home View with welcome text and explanation
                    HomeView(tabSelection: $tabSelection).tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }.tag(1)
                    // List all sessions
                    SessionListView().tabItem {
                        Image(systemName: "list.bullet.rectangle.portrait.fill")
                        Text("Sessions")
                    }.tag(2)
                    // Configure the application
                    SettingsView().tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }.tag(3)
                }
            }
        }
    }
    
    /**
     Whether the keyboard is enabled in the settings
     */
    var keyboardEnabled: Bool {
        keyboardState.isKeyboardEnabled && keyboardState.isFullAccessEnabled
    }
    
    /**
     Whether the keyboard is selected as active keyboard
     */
    var keyboardActive: Bool {
        keyboardState.isKeyboardCurrentlyActive
    }
}
