//
//  DeviceSystemControlStatus.swift
//  AquaGuard-Watch Watch App
//
//  Created by Tristan Listanco on 8/3/24.
//

import SwiftUI

struct DeviceSystemStatusControls: View {
    var deviceStatus: DeviceStatus

    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                // Action to refresh the system
            }) {
                Label("Refresh Device", systemImage: "arrow.clockwise")
            }
            .buttonStyle(.borderedProminent)
            .tint(tintColor)

            Button(role: .destructive, action: {
                // Action to reset the device
            }) {
                Label("Reset", systemImage: "trash")
            }
            .buttonStyle(.bordered)
            .tint(.red)
        }
        .padding()

        .foregroundColor(.white)
    }

    // Determine the tint color based on device status
    private var tintColor: Color {
        switch deviceStatus {
        case .online:
            return .green
        case .idle:
            return .yellow
        case .offline:
            return .red
        case .unknown:
            return .gray
        }
    }
}

#Preview {
    DeviceSystemStatusControls(deviceStatus: .online) // Provide a sample status
}
