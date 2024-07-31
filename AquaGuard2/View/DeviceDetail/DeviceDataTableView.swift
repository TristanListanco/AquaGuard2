//
//  DeviceDataTableView.swift
//  AquaGuard2
//
//  Created by Tristan Listanco on 7/30/24.
//

import SwiftUI

struct DeviceDataTableView: View {
    let selectedDeviceData: [SensorValue]

    var body: some View {
        NavigationView {
            Table(selectedDeviceData) {
                TableColumn("Date") { element in
                    Text(element.date, format: .dateTime.month().day().year())
                        .animation(.default, value: element.date)
                        .contentTransition(.numericText())
                }
                TableColumn("Value") { element in
                    Text("\(element.value) ppm")
                        .animation(.default, value: element.value)
                        .contentTransition(.numericText())
                }
                TableColumn("Status") { _ in
                    Text("NORMAL")
                }
            }
            .navigationTitle("Device Data")
        }
    }
}

//#Preview {
//    DeviceDataTableView()
//}
