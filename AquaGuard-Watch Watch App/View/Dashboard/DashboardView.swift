//
//  DashboardView.swift
//  AquaGuard-Watch Watch App
//
//  Created by Tristan Listanco on 8/3/24.
//

import SwiftUI

struct DashboardView: View {
    @State private var selectedDevice: DeviceViewModel?
    let deviceViewModels = DeveloperPreview.shared.dummyDeviceViewModels()

    var body: some View {
        NavigationSplitView {
            List(deviceViewModels, id: \.device.id, selection: $selectedDevice) { viewModel in
                NavigationLink(value: viewModel) {
                    DeviceCard(viewModel: viewModel)
                        .frame(maxWidth: .infinity)
                }
            }
            .listStyle(.carousel)
            .padding(.horizontal)
            .navigationTitle("Devices")
        } detail: {
            if let selectedDevice = selectedDevice {
                DeviceDetailView(deviceViewModel: selectedDevice)
            } else {
                Text("Select a device")
            }
        }
    }
}

#Preview {
    DashboardView()
}
