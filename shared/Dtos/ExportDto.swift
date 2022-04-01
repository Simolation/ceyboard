//
//  ExportDto.swift
//  demtext
//
//  Created by Simon Osterlehner on 14.02.22.
//

import Foundation

public class ExportDto: Encodable {
    var exportDate = Date()
    var device: String = DeviceInfo.unameMachine
    var appVersion: String? = Bundle.main.buildVersionNumber
    
    var gender: String?
    var birthyear: Int?
    var studyId: String?
    
    var sessions: [Session] = []
    var matrix: [[[Float]]] = []
}
