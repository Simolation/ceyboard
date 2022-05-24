//
//  DeviceInfo.swift
//  ceyboard
//
//  Created by Simon Osterlehner on 15.02.22.
//

import Foundation

public struct DeviceInfo {
    /**
     Return the device version
     */
    static var unameMachine: String {
        var utsnameInstance = utsname()
        uname(&utsnameInstance)
        let optionalString: String? = withUnsafePointer(to: &utsnameInstance.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }
        return optionalString ?? "N/A"
    }
}
