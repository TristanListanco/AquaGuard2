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
    case tds = "TDS"
    case waterFlow = "Water Flow"
    case ec = "EC"
    case turbidity = "Turbidity"
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
    @State private var fileName: String = "data.csv"
    @State private var isDeviceSettingsPresented = false

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
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                TipView(monitordeviceTip)
                Picker("Data Range", selection: $selectedDataRange) {
                    ForEach(DataRange.allCases, id: \.self) { range in
                        Text(range.rawValue).tag(range)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.bottom)
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
                Form {
                    Section(header: Text("Statistical Analysis")) {
                        LabeledContent("Daily Average", value: "\(dailyAverage.formatted()) ppm")
                            .contentTransition(.numericText())
                            .animation(.default, value: latestValue)

                        LabeledContent("Weekday Average", value: "\(weekdayAverage.formatted()) ppm")
                            .contentTransition(.numericText())
                            .animation(.default, value: latestValue)

                        LabeledContent("Weekend Average", value: "\(weekendAverage.formatted()) ppm")
                            .contentTransition(.numericText())
                            .animation(.default, value: latestValue)

                        LabeledContent("Highest Record", value: "\(highestRecord.formatted()) ppm")
                            .contentTransition(.numericText())
                            .animation(.default, value: latestValue)
                    }

                    Table(selectedDeviceData) {
                        TableColumn("Date") { element in
                            Text(element.date, format: .dateTime.month().day().year())
                                .animation(.default, value: latestValue)
                                .contentTransition(.numericText())
                        }
                        TableColumn("Value") { element in
                            Text("\(element.value) ppm")
                                .animation(.default, value: latestValue)
                                .contentTransition(.numericText())
                        }
                        TableColumn("Status") { _ in
                            Text("NORMAL")
                        }
                    }
                    .padding()
                    .animation(.default, value: selectedDeviceData)
                }

                .formStyle(.grouped)
                #else
                GroupBox {
                    LabeledContent("Daily Average", value: "\(dailyAverage.formatted()) ppm")
                        .contentTransition(.numericText())
                        .fontWeight(.medium)
                }

                GroupBox {
                    LabeledContent("Weekday Average", value: "\(weekdayAverage.formatted()) ppm")
                        .contentTransition(.numericText())
                        .fontWeight(.medium)
                }

                GroupBox {
                    LabeledContent("Weekend Average", value: "\(weekendAverage.formatted()) ppm")
                        .contentTransition(.numericText())
                        .fontWeight(.medium)
                }

                GroupBox {
                    LabeledContent("Highest Record:", value: "\(highestRecord.formatted()) ppm")
                        .contentTransition(.numericText())
                        .fontWeight(.medium)
                }

                Table(selectedDeviceData) {
                    TableColumn("Date") { element in
                        Text(element.date, format: .dateTime.month().day().year())
                            .animation(.default, value: latestValue)
                            .contentTransition(.numericText())
                    }
                    TableColumn("Value") { element in
                        Text("\(element.value) ppm")
                            .animation(.default, value: latestValue)
                            .contentTransition(.numericText())
                    }
                    TableColumn("Status") { _ in
                        Text("NORMAL")
                    }
                }
                .padding()
                .animation(.default, value: selectedDeviceData)

                #endif

                Spacer()
            }
            .padding()
            .navigationTitle(deviceViewModel.device.name)
        }
        .onAppear {
            loadData()
        }
        .onChange(of: deviceViewModel) { _ in
            loadData()
        }
        .onChange(of: selectedDataType) { _ in
            loadData()
        }
        .toolbar {
            ToolbarItem {
                Button {
                    // Action for the new button
                    isDeviceSettingsPresented.toggle()

                } label: {
                    Label("Device Settings", systemImage: "wrench.and.screwdriver")
                }
            }
            ToolbarItem {
                Button {
                    // Action for the new button
                    isFileExporterPresented.toggle()
                } label: {
                    Label("Device Settings", systemImage: "arrow.down.document")
                }
            }
            ToolbarItem {
                Menu {
                    Text("View Options")
                        .font(.footnote)
                    Divider()
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
                                    case .tds:
                                        Image(systemName: "waveform.path.ecg")
                                    case .waterFlow:
                                        Image(systemName: "drop.triangle")
                                    case .ec:
                                        Image(systemName: "bolt")
                                    case .turbidity:
                                        Image(systemName: "cloud.rain")
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
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .imageScale(.medium)
                        .font(.system(size: 24))
                }
            }
            // Add another ToolbarItem here
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

    func loadData() {
        Task {
            switch selectedDataType {
            case .temperature:
                selectedDeviceData = deviceViewModel.device.temperatureData
            case .pH:
                selectedDeviceData = deviceViewModel.device.pHData
            case .tds:
                selectedDeviceData = deviceViewModel.device.tdsData
            case .waterFlow:
                selectedDeviceData = deviceViewModel.device.waterFlowData
            case .ec:
                selectedDeviceData = deviceViewModel.device.ecData
            case .turbidity:
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
            SensorValue(date: date(2023, 5, 3), value: 62),
            SensorValue(date: date(2023, 5, 4), value: 40),
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
