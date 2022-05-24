//
//  BundleExtension.swift
//  ceyboard
//
//  Created by Simon Osterlehner on 16.02.22.
//

import Foundation

/**
 Get information about the current application version
 */
extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    var releaseVersionNumberPretty: String {
        return "v\(releaseVersionNumber ?? "1.0.0")"
    }
}
