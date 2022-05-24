//
//  LaunchPageTwoView.swift
//  ceyboard
//
//  Created by Simon Osterlehner on 15.02.2022.
//

import SwiftUI

struct LaunchPageTwoView: View {
    @AppStorage("profile.gender", store: UserDefaults(suiteName: SuiteName.name)) var profileGender: String = ""
    @AppStorage("profile.birthyear", store: UserDefaults(suiteName: SuiteName.name)) var profileBirthyear = 0
    @AppStorage("profile.studyId", store: UserDefaults(suiteName: SuiteName.name)) var studyId = ""
    
    var nextPage: () -> Void
    
    var body: some View {
        LaunchPageLayout(currentStep: 2, totalSteps: 4, title: "Personal Information", description: "To help us better classify the collected data, please provide your gender, year of birth and the study ID you received.", showButton: true, disableButton: !allowedToContinue, action: nextPage, button: {
            HStack(alignment: .center, spacing: 5) {
                Text("Continue")
                Spacer()
                Image(systemName: "chevron.right")
            }
        }) {
            VStack(alignment: .leading, spacing: 22) {
                Section(header: Text("Personal information").font(.headline).foregroundColor(.gray)) {
                    VStack(alignment: .leading, spacing: 9) {
                        HStack {
                            Text("Gender")
                            Spacer()
                            Picker(
                                selection: $profileGender,
                                label: Text("Gender")
                            ) {
                                ForEach(["Other", "Male", "Female"], id: \.self) {
                                    Text($0).tag($0.lowercased())
                                }
                            }
                        }
                        HStack {
                            Text("Year of birth")
                            Spacer()
                            YearPicker(label: "Year of birth", selection: $profileBirthyear)
                        }
                    }
                }
                
                Section(header: Text("Study identifier").font(.headline).foregroundColor(.gray)) {
                    TextField("Please enter your study-ID", text: $studyId)
                        .keyboardType(.numberPad)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.05))
            .cornerRadius(9)
        }
    }
    
    var allowedToContinue: Bool {
        profileGender != "" && profileBirthyear > 0 && studyId != ""
    }
}

struct LaunchPageTwoView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchPageTwoView(nextPage: {})
    }
}
