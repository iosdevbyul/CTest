//
//  DataForm.swift
//  CTest
//
//  Created by PNT001 on 1/9/24.
//

import Foundation

// MARK: - Welcome
struct DataForm: Codable {
    let userId: String
    var device: Device
    var distance, steps, heartRateVariabilitySDNN, heartRate: [AmassData]

    enum CodingKeys: String, CodingKey {
        case userId
        case device = "Device"
        case distance = "Distance"
        case steps = "Steps"
        case heartRateVariabilitySDNN = "HeartRateVariabilitySDNN"
        case heartRate = "HeartRate"
    }
}

// MARK: - Device
struct Device: Codable {
    var hardware, software: String
}

// MARK: - AmassData
struct AmassData: Codable {
    let quantity: Double
    let startDate, endDate: String
}
