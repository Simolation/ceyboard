//
//  IntroductionExplanation.swift
//  ceyboard
//
//  Created by Simon Osterlehner on 26.02.22.
//

import SwiftUI

struct IntroductionExplanation: View {
    var body: some View {
        Text("Thank you for participating in the typing behavior study. The purpose of the study is threefold.")
        VStack(alignment: .leading, spacing: 7) {
            HStack(alignment: .top) {
                Text("1.")
                Text("Validation of the functionality of the ceyboard app with regard to a clinical trial on dementia.")
            }
            HStack(alignment: .top) {
                Text("2.")
                Text("Exploratory data analysis and pattern search in mobile typing data obtained from a standard keyboard on iOS devices in everyday situations.")
            }
            HStack(alignment: .top) {
                Text("3.")
                Text("Statistical hypothesis testing to test assumptions about normal typing behavior and associated distributions.")
            }
        }
        Text("At this point, you should have already signed a written consent to use your data as well as the information about the study. If you still have questions, we are happy to assist you. You may contact your study conductor at any time. Please be sure to use the ceyboard keyboard and not to confuse it with the standard Apple keyboard, as it looks similar.")
        Text("Again, thank you for your participation. We look forward to sharing the final results of this study with you.")
    }
}

struct IntroductionExplanation_Previews: PreviewProvider {
    static var previews: some View {
        IntroductionExplanation()
    }
}
