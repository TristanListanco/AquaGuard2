//
//  Device.swift
//  AquaGuard2
//
//  Created by Tristan Listanco on 7/29/24.
//

import Foundation

enum DeviceStatus: String, Codable {
    case online = "ONLINE"
    case offline = "OFFLINE"
    case idle = "IDLE"
    case unknown // Default case
}

struct SensorValue: Identifiable, Codable, Hashable {
    let date: Date
    var value: Double
    var id: Date { date }
}

struct Device: Identifiable, Codable, Hashable, Equatable {
    var id: String
    var name: String
    var location: String
    var lastUpdated: String
    var status: DeviceStatus
    var temperatureData: [SensorValue]
    var pHData: [SensorValue]
    var tdsData: [SensorValue]
    var waterFlowData: [SensorValue]
    var ecData: [SensorValue]
    var turbidityData: [SensorValue]
    static func == (lhs: Device, rhs: Device) -> Bool {
        return lhs.id == rhs.id
    }
}
