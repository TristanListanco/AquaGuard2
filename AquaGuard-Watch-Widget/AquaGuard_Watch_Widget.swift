//
//  AquaGuard_Watch_Widget.swift
//  AquaGuard-Watch-Widget
//
//  Created by Tristan Listanco on 8/4/24.
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

    func recommendations() -> [AppIntentRecommendation<ConfigurationAppIntent>] {
        // Create an array with all the preconfigured widgets to show.
        [AppIntentRecommendation(intent: ConfigurationAppIntent(), description: "Example Widget")]
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    var selectedDeviceData: [SensorValue] = []
    var sensorType: SensorType = .temperature
    var deviceLocation: String = "" // Add this property
}

struct AquaGuard_Watch_WidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "sensor")
                    Text(entry.configuration.selectedDevice)
                    Spacer()
                    Text(sensorTypeName(for: entry.sensorType))
                        .foregroundStyle(.secondary)
                }
                .foregroundStyle(.primary)
                .font(.footnote)
                .foregroundColor(.white)

                Chart(entry.selectedDeviceData) { element in
                    BarMark(
                        x: .value("Time", element.date, unit: .day),
                        y: .value("Value", element.value)
                    )
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .opacity(0.7)
                }
                .chartXAxis {
                    AxisMarks(stroke: StrokeStyle(lineWidth: 0)) // Hides X axis
                }
                .chartYAxis(.hidden)
                .background(Color.clear) // Optional: Clear background
                .animation(.default, value: entry.selectedDeviceData)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensures full use of space
        }

        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .widgetURL(URL(string: "your-url-here")) // Optional: Handle tap to open URL
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

    private func sensorTypeName(for sensorType: SensorType) -> String {
        switch sensorType {
        case .temperature:
            return "Temperature"
        case .pH:
            return "pH Level"
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
}

@main
struct AquaGuard_Watch_Widget: Widget {
    let kind: String = "AquaGuard_Watch_Widget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            AquaGuard_Watch_WidgetEntryView(entry: entry)
                .containerBackground(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(.cyan), // #32ADE6
                            Color(.blue) // #007AFF
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    for: .widget
                )
        }
        .supportedFamilies([.accessoryRectangular , .accessoryCircular])
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

#Preview(as: .accessoryRectangular) {
    AquaGuard_Watch_Widget()
} timeline: {
    SimpleEntry(date: .now, configuration: .device1pH, deviceLocation: "Buru-un, Iligan City")
    SimpleEntry(date: .now, configuration: .device2Conductivity, deviceLocation: "Buru-un, Iligan City")
}
