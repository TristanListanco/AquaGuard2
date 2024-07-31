//  DeviceViewModel.swift
//  AquaGuard2
//
//  Created by Tristan Listanco on 7/29/24.
//

import Combine
import Foundation

class DeviceViewModel: ObservableObject, Equatable, Hashable {
    @Published var device: Device
    private var cancellables = Set<AnyCancellable>()

    init(device: Device) {
        self.device = device
    }

    // Update device properties
    func updateName(_ newName: String) {
        device.name = newName
    }

    func updateLocation(_ newLocation: String) {
        device.location = newLocation
    }

    func updateLastUpdated(_ newLastUpdated: String) {
        device.lastUpdated = newLastUpdated
    }

    // Update status with a String value
    func updateStatus(_ newStatus: String) {
        device.status = DeviceStatus(rawValue: newStatus) ?? .unknown
    }

    // Update sensor data
    func updateTemperatureData(_ newData: [SensorValue]) {
        device.temperatureData = newData
    }

    func updatePHData(_ newData: [SensorValue]) {
        device.pHData = newData
    }

    func updateTDSData(_ newData: [SensorValue]) {
        device.tdsData = newData
    }

    func updateWaterFlowData(_ newData: [SensorValue]) {
        device.waterFlowData = newData
    }

    func updateECData(_ newData: [SensorValue]) {
        device.ecData = newData
    }

    func updateTurbidityData(_ newData: [SensorValue]) {
        device.turbidityData = newData
    }

    // Add a new sensor value
    func addTemperatureData(_ newValue: SensorValue) {
        device.temperatureData.append(newValue)
    }

    func addPHData(_ newValue: SensorValue) {
        device.pHData.append(newValue)
    }

    func addTDSData(_ newValue: SensorValue) {
        device.tdsData.append(newValue)
    }

    func addWaterFlowData(_ newValue: SensorValue) {
        device.waterFlowData.append(newValue)
    }

    func addECData(_ newValue: SensorValue) {
        device.ecData.append(newValue)
    }

    func addTurbidityData(_ newValue: SensorValue) {
        device.turbidityData.append(newValue)
    }

    // Load data method with Swift Concurrency
    func loadData() async {
        // Fetching dummy data asynchronously
        do {
            async let dummyDevices = await DeveloperPreview.shared.dummyDevices();
            if let dummyDevice = await dummyDevices.first(where: { $0.id == device.id }) {
                device = dummyDevice
            } else {
                print("Device with id \(device.id) not found in dummy data")
            }
        } catch {
            print("Error loading device data: \(error.localizedDescription)")
        }
    }

    // Equatable conformance
    static func == (lhs: DeviceViewModel, rhs: DeviceViewModel) -> Bool {
        return lhs.device.id == rhs.device.id
    }

    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(device.id)
    }
}
