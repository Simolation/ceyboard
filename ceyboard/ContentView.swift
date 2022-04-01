//
//  ContentView.swift
//  demtext
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
                // Show main Content
                TabView(selection: $tabSelection) {
                    HomeView(tabSelection: $tabSelection).tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }.tag(1)
                    SessionListView().tabItem {
                        Image(systemName: "list.bullet.rectangle.portrait.fill")
                        Text("Sessions")
                    }.tag(2)
                    SettingsView().tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }.tag(3)
                }
            }
        }
    }
    
    var keyboardEnabled: Bool {
        keyboardState.isKeyboardEnabled && keyboardState.isFullAccessEnabled
    }
    
    var keyboardActive: Bool {
        keyboardState.isKeyboardCurrentlyActive
    }
}
