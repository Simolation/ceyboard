//
//  LaunchPageOneView.swift
//  ceyboard
//
//  Created by Constantin Ehmanns on 16.12.21.
//

import SwiftUI

struct LaunchPageOneView: View {
    
    let nextPage: () -> Void
    
    var body: some View {
        LaunchPageLayout(currentStep: 1, totalSteps: 4, title: "Dear participant", description: "Welcome to the ceyboard application.", showButton: true, disableButton: false, action: nextPage, button: {
            HStack(alignment: .center, spacing: 5) {
                Text("Continue")
                Spacer()
                Image(systemName: "chevron.right")
            }
        }) {
            IntroductionExplanation()
        }
    }
}

struct LaunchPageOneView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchPageOneView(nextPage: {})
    }
}
