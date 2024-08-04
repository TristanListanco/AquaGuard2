//
//  AppIntent.swift
//  AquaGuard-Watch-Widget
//
//  Created by Tristan Listanco on 8/4/24.
//

import AppIntents
import WidgetKit

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Water Quality Monitoring" }
    static var description: IntentDescription { "Select a device and sensor type to display its data." }

    @Parameter(title: "Device", default: "Device 1")
    var selectedDevice: String

    @Parameter(title: "Sensor Type", default: "pH")
    var selectedSensorType: String
}
