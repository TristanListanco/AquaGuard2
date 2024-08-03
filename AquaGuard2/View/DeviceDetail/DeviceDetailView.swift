//
//  DeviceDetailView.swift
//  AquaGuard2
//
//  Created by Tristan Listanco on 7/29/24.
//

import Charts
import SwiftUI
import TipKit
import UniformTypeIdentifiers

struct SalesSummary: Identifiable, Equatable {
    let weekday: Date
    var value: Int

    var id: Date { weekday }
}

func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
    var components = DateComponents()
    components.year = year
    components.month = month
    components.day = day
    return Calendar.current.date(from: components) ?? Date()
}

enum DataType: String, CaseIterable {
    case temperature = "Temperature"
    case pH
    case TDS
    case WaterFlow = "Water Flow"
    case EC
    case Turbidity
}

enum DataRange: String, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
}

struct DeviceDetailView: View {
    @ObservedObject var deviceViewModel: DeviceViewModel
    @State private var selectedDataType: DataType = .temperature
    @State private var selectedDataRange: DataRange = .daily
    @State private var selectedDeviceData: [SensorValue] = []
    @State private var isFileExporterPresented = false
    @State private var isTableViewPresented = false
    @State private var fileName: String = "data.csv"
    @State private var isDeviceSettingsPresented = false

    // State variables for the popover
    @State private var isPopoverPresented = false
    @State private var newDate = Date()
    @State private var newTime = Date()
    @State private var newValue = ""

    var averageValue: Double {
        Computations.averageValue(for: selectedDeviceData)
    }

    var latestValue: Double {
        Computations.latestValue(for: selectedDeviceData)
    }

    var latestDate: String {
        guard let latestData = selectedDeviceData.max(by: { $0.date < $1.date }) else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: latestData.date)
    }

    var dailyAverage: Double {
        Computations.dailyAverage(for: selectedDeviceData)
    }

    var weekdayAverage: Double {
        Computations.weekdayAverage(for: selectedDeviceData)
    }

    var weekendAverage: Double {
        Computations.weekendAverage(for: selectedDeviceData)
    }

    var highestRecord: Double {
        Computations.highestRecord(for: selectedDeviceData)
    }

    let monitordeviceTip = MonitorData()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    TipView(monitordeviceTip)
                    Picker("Data Range", selection: $selectedDataRange) {
                        ForEach(DataRange.allCases, id: \.self) { range in
                            Text(range.rawValue).tag(range)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    GroupBox {
                        VStack(alignment: .leading) {
                            Text("Latest Data:")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(latestValue, format: .number)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .contentTransition(.numericText())
                                .animation(.default, value: latestValue)
                                .fontDesign(.rounded)
                            Text("TODAY")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Chart(selectedDeviceData) { element in
                            BarMark(
                                x: .value("Time", element.date, unit: .day),
                                y: .value("Value", element.value)
                            )
                            .foregroundStyle(.opacity(0.4))
                            RuleMark(
                                y: .value("Average", averageValue)
                            )
                            .lineStyle(StrokeStyle(lineWidth: 3))
                            .annotation(position: .top, alignment: .leading) {
                                Text("Average: \(averageValue, format: .number)")
                                    .font(.footnote)
                                    .fontDesign(.rounded)
                                    .contentTransition(.numericText())
                                    .foregroundStyle(Color.accentColor)
                            }
                        }
                        .animation(.default, value: selectedDeviceData)
                        .frame(height: 200)

                        Label {
                            Text("Latest: \(latestDate)")
                                .foregroundColor(.white)
                                .font(.subheadline)
                            Spacer()
                            Text("\(latestValue, format: .number) BPM")
                                .foregroundColor(.white)
                                .font(.subheadline)
                                .fontDesign(.rounded)
                                .fontWeight(.semibold)

                        } icon: {}
                            .padding()
                            .background(Color.accentColor)
                            .cornerRadius(10)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    #if os(macOS)

                    AboutSensorView(selectedDataType: selectedDataType)
                    #else
                    AboutSensorView(selectedDataType: selectedDataType)

                    #endif
                }
                .padding()
                .navigationTitle(deviceViewModel.device.name)
            }
        }

        .refreshable {}
        .onAppear {
            loadData()
        }
        .onChange(of: deviceViewModel) {
            loadData()
        }
        .onChange(of: selectedDataType) {
            loadData()
        }
        .toolbar {
            ToolbarItem {
                Button(action: {
                    isPopoverPresented.toggle()
                }) {
                    Label("Add Data", systemImage: "plus.circle")
                }
                .popover(isPresented: $isPopoverPresented) {
                    AddDataPopoverView(
                        isPopoverPresented: $isPopoverPresented,
                        newDate: $newDate,
                        newTime: $newTime,
                        newValue: $newValue,
                        addDataAction: {
                            addData()
                        }
                    )
                }
            }
            ToolbarItem {
                Menu {
                    Button {
                        // Action for the new button
                        isFileExporterPresented.toggle()
                    } label: {
                        Label("Download Data", systemImage: "arrow.down.document")
                    }
                    Button {
                        // Action for the new button

                        isDeviceSettingsPresented.toggle()

                    } label: {
                        Label("Device Settings", systemImage: "wrench.and.screwdriver")
                    }
                    Menu("View Options") {
                        ForEach(DataType.allCases, id: \.self) { type in
                            Button {
                                selectedDataType = type
                                loadData()
                            } label: {
                                HStack {
                                    Text(type.rawValue)
                                    Spacer()
                                    if selectedDataType == type {
                                        Image(systemName: "checkmark")
                                    } else {
                                        // Add specific icon for each data type
                                        switch type {
                                        case .temperature:
                                            Image(systemName: "thermometer")
                                        case .pH:
                                            Image(systemName: "leaf.arrow.circlepath")
                                        case .TDS:
                                            Image(systemName: "circle.hexagongrid")
                                        case .WaterFlow:
                                            Image(systemName: "water.waves.and.arrow.trianglehead.up")
                                        case .EC:
                                            Image(systemName: "bolt")
                                        case .Turbidity:
                                            Image(systemName: "atom")
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Button(role: .destructive) {
                        // Action for Reset Data
                    } label: {
                        Label("Reset Data", systemImage: "trash")
                    }
                }
                label: {
                    Image(systemName: "ellipsis.circle")
                        .imageScale(.medium)
                        .font(.system(size: 24))
                }
            }
        }

        .fileExporter(isPresented: $isFileExporterPresented, document: createDocument(), contentType: .plainText, defaultFilename: fileName) { result in
            switch result {
            case .success(let url):
                print("File exported to: \(url)")
            case .failure(let error):
                print("Failed to export file: \(error.localizedDescription)")
            }
        }
    }

    // popover
    private func addData() {
        guard let value = Double(newValue) else { return }
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: newDate)
        let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: newTime)
        var combinedComponents = DateComponents()
        combinedComponents.year = dateComponents.year
        combinedComponents.month = dateComponents.month
        combinedComponents.day = dateComponents.day
        combinedComponents.hour = timeComponents.hour
        combinedComponents.minute = timeComponents.minute

        if let combinedDate = Calendar.current.date(from: combinedComponents) {
            let newSensorValue = SensorValue(date: combinedDate, value: value)
            selectedDeviceData.append(newSensorValue)
            isPopoverPresented = false
        }
    }

    func loadData() {
        Task {
            switch selectedDataType {
            case .temperature:
                selectedDeviceData = deviceViewModel.device.temperatureData
            case .pH:
                selectedDeviceData = deviceViewModel.device.pHData
            case .TDS:
                selectedDeviceData = deviceViewModel.device.tdsData
            case .WaterFlow:
                selectedDeviceData = deviceViewModel.device.waterFlowData
            case .EC:
                selectedDeviceData = deviceViewModel.device.ecData
            case .Turbidity:
                selectedDeviceData = deviceViewModel.device.turbidityData
            }
        }
    }

    private func createDocument() -> TextDocument {
        let csvData = selectedDeviceData.map { "\($0.date),\($0.value)" }.joined(separator: "\n")
        return TextDocument(text: csvData)
    }

    struct TextDocument: FileDocument {
        var text: String

        static var readableContentTypes: [UTType] { [.plainText] }

        init(text: String) {
            self.text = text
        }

        init(configuration: ReadConfiguration) throws {
            guard let data = configuration.file.regularFileContents,
                  let text = String(data: data, encoding: .utf8)
            else {
                throw CocoaError(.fileReadCorruptFile)
            }
            self.text = text
        }

        func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
            let data = text.data(using: .utf8) ?? Data()
            return FileWrapper(regularFileWithContents: data)
        }
    }
}

#Preview {
    let sampleDevice = Device(
        id: "1",
        name: "Example Device",
        location: "Sample Location",
        lastUpdated: "10:00 AM",
        status: .online,
        temperatureData: [
            SensorValue(date: date(2023, 5, 2), value: 74),
            SensorValue(date: date(2023, 5, 3), value: 73),
            SensorValue(date: date(2023, 5, 4), value: 74),
            SensorValue(date: date(2023, 5, 5), value: 78),
            SensorValue(date: date(2023, 5, 6), value: 72)
        ],
        pHData: [],
        tdsData: [],
        waterFlowData: [],
        ecData: [],
        turbidityData: []
    )
    DeviceDetailView(deviceViewModel: DeviceViewModel(device: sampleDevice))
}
