//
//  SettingsView.swift
//  demtext
//
//  Created by Simon Osterlehner on 14.02.22.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("useUmlaute", store: UserDefaults(suiteName: SuiteName.name)) var useUmlaute = false
    @AppStorage("useAutocorrect", store: UserDefaults(suiteName: SuiteName.name)) var useAutocorrect = false
    @AppStorage("profile.gender", store: UserDefaults(suiteName: SuiteName.name)) var profileGender = ""
    @AppStorage("profile.birthyear", store: UserDefaults(suiteName: SuiteName.name)) var profileBirthyear = 0
    @AppStorage("profile.studyId", store: UserDefaults(suiteName: SuiteName.name)) var studyId = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal information")) {
                    Picker(
                        selection: $profileGender,
                        label: Text("Gender")
                    ) {
                        ForEach(["Other", "Male", "Female"], id: \.self) {
                            Text($0).tag($0.lowercased())
                        }
                    }
                    YearPicker(label: "Year of birth", selection: $profileBirthyear)
                }
                
                Section(header: Text("Study identifier")) {
                    TextField("Study-ID", text: $studyId)
                        .keyboardType(.numberPad)
                }
                
                Section(header: Text("Keyboard behavior and layout")) {
                    Toggle(isOn: $useUmlaute) {
                        Text("Use umlauts")
                    }
                    Toggle(isOn: $useAutocorrect) {
                        Text("Apply autocorrect suggestions")
                    }
                }
                
                Section(header: Text("Export")) {
                    NavigationLink(destination: ExportView()) {
                        Text("Export")
                    }
                }
                
                Section(header: Text("FAQ")) {
                    NavigationLink(destination: {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 7) {
                                IntroductionExplanation()
                            }.padding()
                        }.navigationBarTitle(Text("Study introduction"))
                    }) {
                        Text("Study introduction")
                    }
                }
            }
            .navigationBarTitle(Text("Settings"))
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
