//
//  ExportView.swift
//  demtext
//
//  Created by Simon Osterlehner on 25.01.22.
//

import SwiftUI

struct ExportView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var includeText = false
    @State private var loading = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                VStack(alignment: .leading, spacing: 7) {
                    Text("What will be exported?").font(.headline)
                    Text("When an export is created, it will contain general information like app version, device, gender, birthyear, and the study id.").foregroundColor(.gray)
                    Text("Likewise, the collected typing sessions including the app in which the keyboard was used, the start and end date, and the individual typing events consisting of the action performed (typed character, emoji, auto-complete, etc.) and the timestamp are exported.").foregroundColor(.gray)
                    Text("A matrix with metrics about your typing behavior in relation to specific characters is exported as well.").foregroundColor(.gray)
                    Text("Neither the typed text nor the individual typed letters leave the smartphone!").bold().foregroundColor(.red)
                }
                if loading {
                    ProgressView()
                } else {
                    Button("Export", action: exportAsJson)
                }
                Spacer()
            }
            .buttonStyle(.bordered)
            .padding()
            .navigationTitle(Text("Export"))
        }
    }
    
    private func exportAsJson() {
        // Show a loading indicator
        loading = true
        
        DispatchQueue.background(background: { () -> String? in
            do {
                // Generate JSON
                let sessionsToExport = try viewContext.fetch(Session.fetchRequest())
                
                let characterRealtion = CharacterRelation(sessions: sessionsToExport)
                let matrix = characterRealtion.createRelations()
                
                let userDefaults = UserDefaults(suiteName: SuiteName.name)!
                
                // Create export instance
                let toExport = ExportDto()
                
                // Add personal information
                toExport.gender = userDefaults.string(forKey: "profile.gender")
                toExport.birthyear = userDefaults.integer(forKey: "profile.birthyear")
                
                toExport.studyId = userDefaults.string(forKey: "profile.studyId")
                
                // Add sessions and matrix
                toExport.sessions = sessionsToExport
                toExport.matrix = matrix
                
                let encoder = JSONEncoder()
                encoder.userInfo[Session.includeTextUserInfoKey] = self.includeText
                
                // Use the ISO date format instead of weird Apple unix timestamps which start in 2001
                encoder.dateEncodingStrategy = .millisecondsSince1970
                
                let jsonData = try encoder.encode(toExport)
                
                // When the JSON encoding was successfull, return the data
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    return jsonString
                }
            } catch {
                print("Error fetching data from CoreData", error)
            }
            
            // When the data was not successfully returned as JSON, return nil
            return nil
        }, completion: { jsonString in
            
            if let jsonString = jsonString {
                // Share
                let shareActivity = UIActivityViewController(activityItems: [jsonString], applicationActivities: nil)
                
                if let vc = UIApplication.shared.windows.first?.rootViewController{
                    shareActivity.popoverPresentationController?.sourceView = vc.view
                    //Setup share activity position on screen on bottom center
                    shareActivity.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height, width: 0, height: 0)
                    shareActivity.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
                    vc.present(shareActivity, animated: true, completion: nil)
                }
            }
            
            // Hide the loading indicator
            loading = false
        })
    }
}

struct ExportView_Previews: PreviewProvider {
    static var previews: some View {
        ExportView()
    }
}
