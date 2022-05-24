//
//  LaunchPageLayout.swift
//  ceyboard
//
//  Created by Simon Osterlehner on 20.02.22.
//

import SwiftUI

struct LaunchPageLayout<Content: View, ButtonContent: View>: View {
    
    let currentStep: Int
    let totalSteps: Int
    
    let title: String
    let description: String
    
    let showButton: Bool
    let disableButton: Bool
    
    let action: () -> Void
    
    let button: (() -> ButtonContent?)?
    @ViewBuilder var content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            VStack(alignment: .leading, spacing: 7) {
                Text("Step \(currentStep) of \(totalSteps)".uppercased())
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(title)
                    .font(.title.weight(.bold))
            }.padding(EdgeInsets(top: 0, leading: 23, bottom: 0, trailing: 23))
            
            ScrollView {
                VStack(alignment: .leading, spacing: 7) {
                    Text(description)
                        .font(.body)
                    
                    // Main view content
                    content
                        .frame(maxWidth: .infinity)
                        .padding(EdgeInsets(top: 23, leading: 0, bottom: 0, trailing: 0))
                    
                    Spacer().frame(maxWidth: .infinity)
                }.padding(EdgeInsets(top: 0, leading: 23, bottom: 0, trailing: 23))
            }.frame(maxWidth: .infinity)
            
            // Button
            if (showButton) {
                VStack(alignment: .center) {
                    Button(action: action) {
                        button?()
                            .frame(maxWidth: .infinity)
                            .padding(EdgeInsets(top: 15, leading: 19, bottom: 15, trailing: 19))
                    }
                    .foregroundColor(.white)
                    .background(!disableButton ? Color("AccentColor") : Color.gray.opacity(0.25))
                    .cornerRadius(9)
                    .disabled(disableButton)
                }
                .padding(EdgeInsets(top: 15, leading: 23, bottom: 0, trailing: 23))
            }
        }
        .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct LaunchPageLayout_Previews: PreviewProvider {
    static var previews: some View {
        LaunchPageLayout(currentStep: 2, totalSteps: 3, title: "This is a title", description: "This is a detailed description", showButton: true, disableButton: false, action: {}, button: {
            Text("Button")
        }) {
            Text("Content")
        }
    }
}
