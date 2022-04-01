//
//  ViewExtension.swift
//  demtext
//
//  Created by Simon Osterlehner on 20.02.22.
//

import Foundation
import SwiftUI

extension View {
  @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
    switch shouldHide {
      case true: self.hidden()
      case false: self
    }
  }
}
