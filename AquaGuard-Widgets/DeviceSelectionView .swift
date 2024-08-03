//
//  DeviceSelectionView .swift
//  AquaGuard2
//
//  Created by Tristan Listanco on 8/3/24.
//

import SwiftUI

struct DeviceSelectionView: View {
    @Binding var selectedDevice: Device?
    let devices: [Device]

    var body: some View {
        NavigationView {
            List(devices) { device in
                Button(action: {
                    selectedDevice = device
                }) {
                    Text(device.name)
                }
            }
            .navigationTitle("Select a Device")
        }
    }
}
