//
//  DeviceCard.swift
//  AquaGuard-Watch Watch App
//
//  Created by Tristan Listanco on 8/3/24.
//

import SwiftUI

struct DeviceCard: View {
    @ObservedObject var viewModel: DeviceViewModel

    var body: some View {
        NavigationLink(destination: DeviceDetailView(deviceViewModel: viewModel)) {
            VStack(alignment: .leading, spacing: 3) {
                Text(viewModel.device.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    

                Label(viewModel.device.location, systemImage: "location.fill")
                    .font(.footnote)
                    .privacySensitive()
            }
            .padding()
            .cornerRadius(4)
            .shadow(radius: 2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct DeviceCard_Previews: PreviewProvider {
    static var previews: some View {
        let sampleSensorData = [
            SensorValue(date: Date(), value: 50),
            SensorValue(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, value: 55),
            SensorValue(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, value: 60)
        ]

        let sampleDevice = Device(
            id: "1",
            name: "Example Device",
            location: "Sample Location",
            lastUpdated: "10:00 AM",
            status: .online,
            temperatureData: sampleSensorData,
            pHData: sampleSensorData,
            tdsData: sampleSensorData,
            waterFlowData: sampleSensorData,
            ecData: sampleSensorData,
            turbidityData: sampleSensorData
        )

        let viewModel = DeviceViewModel(device: sampleDevice)
        @Namespace var namespace

        return DeviceCard(viewModel: viewModel)
    }
}
