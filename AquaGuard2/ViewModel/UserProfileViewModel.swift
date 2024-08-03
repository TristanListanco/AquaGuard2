//
//  UserProfileViewModel.swift
//  AquaGuard2
//
//  Created by Tristan Listanco on 7/29/24.
//

import Foundation
import WidgetKit

class UserProfileViewModel: ObservableObject {
    @Published var userProfile: UserProfile

    init(userProfile: UserProfile) {
        self.userProfile = userProfile
    }

    // Update user profile properties
    func updateName(_ newName: String) {
        userProfile.name = newName
        reloadWidget()
    }

    func updateEmail(_ newEmail: String) {
        userProfile.email = newEmail
        reloadWidget()
    }

    func updateAddress(_ newAddress: String) {
        userProfile.address = newAddress
        reloadWidget()
    }

    func updateNumberOfDevices(_ newNumberOfDevices: Int) {
        userProfile.numberOfDevices = newNumberOfDevices
        reloadWidget()
    }

    func updatePassword(_ newPassword: String) {
        userProfile.password = newPassword
        reloadWidget()
    }

    func updateHobbies(_ newHobbies: [String]) {
        userProfile.hobbies = newHobbies
        reloadWidget()
    }

    func updateOwnerImageUrl(_ newOwnerImageUrl: String) {
        userProfile.ownerImageUrl = newOwnerImageUrl
        reloadWidget()
    }

    // Update devices
    func addDevice(_ device: Device) async {
        await MainActor.run {
            userProfile.devices.append(device)
            userProfile.numberOfDevices = userProfile.devices.count
            reloadWidget()
        }
    }

    func updateDevice(_ updatedDevice: Device) async {
        if let index = userProfile.devices.firstIndex(where: { $0.id == updatedDevice.id }) {
            await MainActor.run {
                userProfile.devices[index] = updatedDevice
                reloadWidget()
            }
        }
    }

    func removeDevice(withId id: String) async {
        await MainActor.run {
            userProfile.devices.removeAll { $0.id == id }
            userProfile.numberOfDevices = userProfile.devices.count
            reloadWidget()
        }
    }

    func reloadWidget() {
        DispatchQueue.main.async {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }

    // Update device sensor data
    func updateDeviceSensorData(deviceId: String, temperatureData: [SensorValue]?, pHData: [SensorValue]?, tdsData: [SensorValue]?, waterFlowData: [SensorValue]?, ecData: [SensorValue]?, turbidityData: [SensorValue]?) async {
        if let index = userProfile.devices.firstIndex(where: { $0.id == deviceId }) {
            await MainActor.run {
                if let temperatureData = temperatureData {
                    userProfile.devices[index].temperatureData = temperatureData
                }
                if let pHData = pHData {
                    userProfile.devices[index].pHData = pHData
                }
                if let tdsData = tdsData {
                    userProfile.devices[index].tdsData = tdsData
                }
                if let waterFlowData = waterFlowData {
                    userProfile.devices[index].waterFlowData = waterFlowData
                }
                if let ecData = ecData {
                    userProfile.devices[index].ecData = ecData
                }
                if let turbidityData = turbidityData {
                    userProfile.devices[index].turbidityData = turbidityData
                }
                reloadWidget()
            }
        }
    }
}
