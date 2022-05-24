//
//  EnabledItem.swift
//  ceyboard
//
//  Created by Simon Osterlehner on 20.02.22.
//

import SwiftUI

struct EnabledItem: View {
    
    let enabled: Bool
    let enabledText: Text
    let disabledText: Text
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: enabled ? "checkmark" : "exclamationmark.triangle.fill")
            (enabled ? enabledText : disabledText).frame(maxWidth: .infinity, alignment: .leading)
        }.foregroundColor(enabled ? .green : .orange)
    }
}

struct EnabledItem_Previews: PreviewProvider {
    static var previews: some View {
        EnabledItem(enabled: true, enabledText: Text("Enabled"), disabledText: Text("Disabled"))
    }
}
