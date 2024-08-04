//
//  DeveloperPreview.swift
//  AquaGuard2
//
//  Created by Tristan Listanco on 7/29/24.
//
import Foundation

class DeveloperPreview {
    static let shared = DeveloperPreview()

    // Generate dummy user profile data
    func dummyUserProfile() -> UserProfile {
        return UserProfile(
            id: UUID(),
            name: "John Doe",
            ownerImageUrl: "https://example.com/johndoe.jpg",
            email: "john.doe@example.com",
            address: "123 Main St",
            numberOfDevices: 3,
            password: "password123",
            hobbies: ["Reading", "Hiking", "Coding"],
            devices: dummyDevices()
        )
    }

    // Example method to create a view model with dummy data
    func dummyUserProfileViewModel() -> UserProfileViewModel {
        let userProfile = dummyUserProfile()
        return UserProfileViewModel(userProfile: userProfile)
    }

    // Generate dummy device data with hardcoded sensor values
    func dummyDevice(id: String, name: String, location: String, lastUpdated: String, status: DeviceStatus, temperatureData: [SensorValue], pHData: [SensorValue], tdsData: [SensorValue], waterFlowData: [SensorValue], ecData: [SensorValue], turbidityData: [SensorValue]) -> Device {
        return Device(
            id: id,
            name: name,
            location: location,
            lastUpdated: lastUpdated,
            status: status,
            temperatureData: temperatureData,
            pHData: pHData,
            tdsData: tdsData,
            waterFlowData: waterFlowData,
            ecData: ecData,
            turbidityData: turbidityData
        )
    }

    // Generate an array of dummy devices with Filipino household names and locations
    func dummyDevices() -> [Device] {
        return [
            dummyDevice(
                id: UUID().uuidString,
                name: "Barangay House 1",
                location: "Lanao del Norte",
                lastUpdated: "10:00 AM",
                status: .online,
                temperatureData: generateSensorValues(startingValue: 22.5, increment: 0.5),
                pHData: generateSensorValues(startingValue: 6.8, increment: 0.1),
                tdsData: generateSensorValues(startingValue: 300, increment: 20),
                waterFlowData: generateSensorValues(startingValue: 1.2, increment: 0.3),
                ecData: generateSensorValues(startingValue: 1.8, increment: 0.1),
                turbidityData: generateSensorValues(startingValue: 2.5, increment: 0.2)
            ),
            dummyDevice(
                id: UUID().uuidString,
                name: "Barangay House 2",
                location: "Buru-un, Iligan City",
                lastUpdated: "11:00 AM",
                status: .offline,
                temperatureData: generateSensorValues(startingValue: 24.5, increment: 0.5),
                pHData: generateSensorValues(startingValue: 6.6, increment: 0.1),
                tdsData: generateSensorValues(startingValue: 310, increment: 20),
                waterFlowData: generateSensorValues(startingValue: 1.3, increment: 0.1),
                ecData: generateSensorValues(startingValue: 1.9, increment: 0.1),
                turbidityData: generateSensorValues(startingValue: 3.0, increment: 0.2)
            ),
            dummyDevice(
                id: UUID().uuidString,
                name: "Barangay House 3",
                location: "Misamis Oriental, Philippines",
                lastUpdated: "12:00 PM",
                status: .idle,
                temperatureData: generateSensorValues(startingValue: 26.5, increment: 0.5),
                pHData: generateSensorValues(startingValue: 6.7, increment: 0.1),
                tdsData: generateSensorValues(startingValue: 320, increment: 20),
                waterFlowData: generateSensorValues(startingValue: 1.4, increment: 0.2),
                ecData: generateSensorValues(startingValue: 2.0, increment: 0.1),
                turbidityData: generateSensorValues(startingValue: 3.5, increment: 0.2)
            )
        ]
    }

    // Example method to create an array of view models with dummy device data
    func dummyDeviceViewModels() -> [DeviceViewModel] {
        return dummyDevices().map { DeviceViewModel(device: $0) }
    }

    // Helper method to create a date object
    private func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        return Calendar.current.date(from: components) ?? Date()
    }

    // Helper method to generate sensor values
    private func generateSensorValues(startingValue: Double, increment: Double) -> [SensorValue] {
        var values: [SensorValue] = []
        let startDate = date(2024, 1, 1)
        for i in 0 ..< 10 {
            let value = SensorValue(date: Calendar.current.date(byAdding: .day, value: i, to: startDate)!, value: startingValue + (increment * Double(i)))
            values.append(value)
        }
        return values
    }
}
