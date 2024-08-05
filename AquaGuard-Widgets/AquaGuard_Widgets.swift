//
//  AquaGuard_Widgets.swift
//  AquaGuard-Widgets
//
//  Created by Tristan Listanco on 8/2/24.
//

import Charts
import SwiftUI
import WidgetKit

enum SensorType: String {
    case temperature = "Temperature"
    case pH
    case TDS
    case waterFlow = "WaterFlow"
    case EC
    case turbidity = "Turbidity"
}

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        let device = fetchDevice(named: configuration.selectedDevice) // Fetch the device
        return SimpleEntry(
            date: Date(),
            configuration: configuration,
            deviceLocation: device.location // Set the location
        )
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        // Fetch the selected device and sensor data
        let device = fetchDevice(named: configuration.selectedDevice)
        let sensorType = SensorType(rawValue: configuration.selectedSensorType) ?? .temperature
        let sensorData = fetchSensorData(for: sensorType, from: device)

        let entries: [SimpleEntry] = [
            SimpleEntry(date: Date(), configuration: configuration, selectedDeviceData: sensorData, sensorType: sensorType, deviceLocation: device.location)
        ]

        return Timeline(entries: entries, policy: .atEnd)
    }

    private func fetchDevice(named name: String) -> Device {
        // Fetch a device from the list of dummy devices by name
        for device in DeveloperPreview.shared.dummyDevices() {
            if device.name == name {
                return device
            }
        }

        // Return a default device if not found
        return DeveloperPreview.shared.dummyDevices().first!
    }

    // Helper method to fetch sensor data
    private func fetchSensorData(for sensorType: SensorType, from device: Device) -> [SensorValue] {
        switch sensorType {
        case .temperature:
            return device.temperatureData
        case .pH:
            return device.pHData
        case .TDS:
            return device.tdsData
        case .waterFlow:
            return device.waterFlowData
        case .EC:
            return device.ecData
        case .turbidity:
            return device.turbidityData
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    var selectedDeviceData: [SensorValue] = []
    var sensorType: SensorType = .temperature
    var deviceLocation: String = "" // Add this property
}

struct AquaGuard_WidgetsEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            // View for small widgets
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "location.fill")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .foregroundColor(.white)
                    VStack(alignment: .leading, spacing: 0) {
                        Text(entry.configuration.selectedDevice)

                        Text(entry.deviceLocation) // Assuming location is also the device name for now
                            .privacySensitive(true)
                            .font(.system(size: 10, weight: .semibold, design: .default))
                    }
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                    .foregroundColor(.white)
                }
                Spacer()
                HStack {
                    if let latestValue = entry.selectedDeviceData.last {
                        Text("\(latestValue.value, specifier: "%.2f") \(unit(for: entry.sensorType))")

                    } else {
                        Text("No data")
                    }
                    Spacer()
                }
                .font(.title)
                .foregroundStyle(.primary)
                .fontDesign(.rounded)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                HStack {
                    getIconForSensorType(entry.sensorType.rawValue)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .foregroundColor(.white)

                    Text(sensorTypeName(for: entry.sensorType))
                }
                .font(.footnote)
                .fontDesign(.rounded)
                .fontWeight(.semibold)
                .foregroundStyle(.tertiary)
                .foregroundColor(.white)
            }

        case .systemMedium:
            // View for medium widgets
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "location.fill")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .foregroundColor(.white)
                        VStack(alignment: .leading, spacing: 0) {
                            Text(entry.configuration.selectedDevice)

                            Text(entry.deviceLocation) // Assuming location is also the device name for now
                                .privacySensitive(true)
                        }
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                        .foregroundColor(.white)
                    }
                    Spacer()
                    HStack {
                        if let latestValue = entry.selectedDeviceData.last {
                            Text("\(latestValue.value, specifier: "%.2f") \(unit(for: entry.sensorType))")

                        } else {
                            Text("No data")
                        }
                        Spacer()
                    }
                    .font(.title)
                    .foregroundStyle(.primary)
                    .fontDesign(.rounded)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    HStack {
                        getIconForSensorType(entry.sensorType.rawValue)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .foregroundColor(.white)

                        Text(sensorTypeName(for: entry.sensorType))
                    }
                    .font(.footnote)
                    .fontDesign(.rounded)
                    .fontWeight(.semibold)
                    .foregroundStyle(.tertiary)
                    .foregroundColor(.white)
                }
                // Chart view for medium widgets
                Chart(entry.selectedDeviceData) { element in
                    BarMark(
                        x: .value("Time", element.date, unit: .day),
                        y: .value("Value", element.value)
                    )
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .chartXAxis {
                    AxisMarks(stroke: StrokeStyle(lineWidth: 0)) // Hides X axis
                }
                .foregroundStyle(.secondary)
                .chartYAxis(.hidden)
                .background(Color.clear) // Optional: Clear background
                .animation(.default, value: entry.selectedDeviceData)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))

        case .systemLarge:
            // View for large widgets
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "location.fill")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .foregroundColor(.white)
                    VStack(alignment: .leading, spacing: 0) {
                        Text(entry.configuration.selectedDevice)

                        Text(entry.deviceLocation) // Assuming location is also the device name for now
                            .privacySensitive(true)
                    }
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                    .foregroundColor(.white)
                }
                Spacer()
                if widgetFamily == .systemLarge {
                    // Chart view for large widgets
                    Chart(entry.selectedDeviceData) { element in
                        BarMark(
                            x: .value("Time", element.date, unit: .day),
                            y: .value("Value", element.value)
                        )
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .chartXAxis {
                        AxisMarks(stroke: StrokeStyle(lineWidth: 0)) // Hides X axis
                    }
                    .foregroundStyle(.secondary)
                    .chartYAxis(.hidden)
                    .background(Color.clear) // Optional: Clear background
                    .animation(.default, value: entry.selectedDeviceData)
                    Spacer()
                }
                HStack {
                    if let latestValue = entry.selectedDeviceData.last {
                        Text("\(latestValue.value, specifier: "%.2f") \(unit(for: entry.sensorType))")

                    } else {
                        Text("No data")
                    }
                    Spacer()
                }
                .font(.title)
                .foregroundStyle(.primary)
                .fontDesign(.rounded)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                HStack {
                    getIconForSensorType(entry.sensorType.rawValue)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .foregroundColor(.white)

                    Text(sensorTypeName(for: entry.sensorType))
                }
                .font(.footnote)
                .fontDesign(.rounded)
                .fontWeight(.semibold)
                .foregroundStyle(.tertiary)
                .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensures full use of space
            .clipShape(RoundedRectangle(cornerRadius: 12))

        default:
            EmptyView()
        }
    }
}

@ViewBuilder
private func getIconForSensorType(_ sensorType: String) -> some View {
    switch SensorType(rawValue: sensorType) {
    case .temperature:
        Image(systemName: "thermometer")
    case .pH:
        Image(systemName: "leaf.arrow.circlepath")
    case .TDS:
        Image(systemName: "circle.hexagongrid")
    case .waterFlow:
        Image(systemName: "water.waves.and.arrow.trianglehead.up")
    case .EC:
        Image(systemName: "bolt")
    case .turbidity:
        Image(systemName: "atom")
    default:
        Image(systemName: "questionmark")
    }
}

private func unit(for sensorType: SensorType) -> String {
    switch sensorType {
    case .temperature:
        return "°C"
    case .pH:
        return "pH"
    case .TDS:
        return "ppm"
    case .waterFlow:
        return "L/min"
    case .EC:
        return "µS/cm"
    case .turbidity:
        return "NTU"
    }
}

private func sensorTypeName(for sensorType: SensorType) -> String {
    switch sensorType {
    case .temperature:
        return "Temperature"
    case .pH:
        return "pH"
    case .TDS:
        return "TDS"
    case .waterFlow:
        return "Water Flow"
    case .EC:
        return "Electrical Conductivity"
    case .turbidity:
        return "Turbidity"
    }
}

struct AquaGuard_Widgets: Widget {
    let kind: String = "AquaGuard_Widgets"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            AquaGuard_WidgetsEntryView(entry: entry)
                .containerBackground(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(.systemCyan), // #32ADE6
                            Color(.systemBlue) // #007AFF
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    for: .widget
                )
        }
        .configurationDisplayName("Select a Widget")
        .description("Monitor water quality and environmental data with AquaGuard")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .accessoryCircular])
    }
}

private extension ConfigurationAppIntent {
    static var device1pH: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.selectedDevice = "Device 1"
        intent.selectedSensorType = "pH"
        return intent
    }

    static var device2Conductivity: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.selectedDevice = "Device 1"
        intent.selectedSensorType = "pH"
        return intent
    }
}

#Preview(as: .systemMedium) {
    AquaGuard_Widgets()
} timeline: {
    SimpleEntry(date: .now, configuration: .device1pH, deviceLocation: "Buru-un, Iligan City")
    SimpleEntry(date: .now, configuration: .device2Conductivity, deviceLocation: "Buru-un, Iligan City")
}
