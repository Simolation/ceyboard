//
//  HomeView.swift
//  demtext
//
//  Created by Constantin Ehmanns on 16.12.21.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var demoText = ""
    @FocusState private var keyboardVisible: Bool
    
    @Binding var tabSelection: Int
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 31) {
                    Text("Use your smartphone like you used to.")
                        .fontWeight(.bold)
                        .font(.system(.title))
                    Text("For this study, the ceyboard keyboard collects metrics about your typing behavior in the background. Nevertheless, no sensitive or personal data is leaving your phone.")
                        .font(.subheadline)
                        .foregroundColor(Color.black)
                    
                    CorrectKeyboardExplanation()
                    
                    VStack(alignment: .leading, spacing: 9) {
                        Text("Try out the keyboard")
                            .font(.headline)
                        
                        VStack {
                            // Demo text input field
                            TextField("Type here to try out the keyboard", text: $demoText)
                                .padding()
                                .submitLabel(.done)
                                .focused($keyboardVisible)
                                .background(.gray.opacity(0.1))
                                .cornerRadius(9)
                                .onSubmit {
                                    if !demoText.isEmpty {
                                        // Clear text field
                                        demoText = ""
                                        
                                        // Close keyboard
                                        self.keyboardVisible = false
                                        
                                        // Move to session tab
                                        tabSelection = 2
                                    }
                                }
                            
                            HStack(alignment: .center) {
                                Button(action: toggleKeyboard) {
                                    Image(systemName: "keyboard").foregroundColor(.gray)
                                }
                                Spacer()
                                Button(action: {
                                    demoText = ""
                                }) {
                                    Image(systemName: "paperplane")
                                }
                            }.padding(EdgeInsets(top: 7, leading: 0, bottom: 7, trailing: 0))
                        }
                    }
                }.padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("ceyboard")
        }
    }
    
    
    private func toggleKeyboard() {
        self.keyboardVisible = !self.keyboardVisible
    }
    
}

struct HomeView_Previews: PreviewProvider {
    @State static private var tabSelection = 1
    static var previews: some View {
        HomeView(tabSelection: $tabSelection)
    }
}
