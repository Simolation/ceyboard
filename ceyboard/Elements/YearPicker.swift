//
//  YearPicker.swift
//  ceyboard
//
//  Created by Simon Osterlehner on 26.02.22.
//

import SwiftUI

struct YearPicker: View {
    // Get the current year and the first available year
    let currentYear = Calendar.current.component(.year, from: Date())
    
    var selection: Binding<Int>
    let label: String
    
    init(label: String, selection: Binding<Int>) {
        self.label = label
        self.selection = selection
    }
    
    var body: some View {
        Picker(label, selection: selection) {
            ForEach(0...120, id: \.self) {
                Text(String(currentYear - $0)).tag(currentYear - $0)
            }
        }
    }
}

struct YearPicker_Previews: PreviewProvider {
    @State static var test = 0
    
    static var previews: some View {
        YearPicker(label: "Test", selection: $test)
    }
}
