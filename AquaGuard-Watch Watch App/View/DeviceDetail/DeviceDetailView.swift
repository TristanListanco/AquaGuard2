//
//  DeviceDetailView.swift
//  AquaGuard-Watch Watch App
//
//  Created by Tristan Listanco on 8/3/24.
//

import Charts
import SwiftData
import SwiftUI

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
    @State private var showModal = false

    var averageValue: Double {
        Computations.averageValue(for: selectedDeviceData)
    }

    var latestValue: Double {
        Computations.latestValue(for: selectedDeviceData)
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

    // Determine the background gradient based on device status
    var containerBackground: AnyGradient {
        switch deviceViewModel.device.status {
        case .online:
            return Color.green.gradient
        case .idle:
            return Color.yellow.gradient
        case .offline:
            return Color.red.gradient
        case .unknown:
            return Color.gray.gradient
        }
    }

    var body: some View {
        TabView {
            VStack(alignment: .leading, spacing: 8) {
                Chart(selectedDeviceData) { element in
                    BarMark(
                        x: .value("Time", element.date, unit: .day),
                        y: .value("Value", element.value)
                    )
                    .foregroundStyle(
                        Color.accentColor.opacity(0.8).blendMode(.overlay)
                    )

                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .chartXAxis {
                    AxisMarks(stroke: StrokeStyle(lineWidth: 0)) // Hides X axis
                }
                .chartYAxis(.hidden)
                .animation(.default, value: selectedDeviceData)

                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: selectedDataType.iconName)
                            .foregroundStyle(.tertiary)
                            .opacity(0.7)
                        Text(selectedDataType.rawValue)
                            .font(.footnote)
                            .fontWeight(.bold).foregroundStyle(.tertiary)
                            .opacity(0.7)
                    }
                    Text(deviceViewModel.device.name)
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundStyle(.primary)
                        .contentTransition(.numericText())
                        .animation(.default, value: latestValue)
                    Text("\(latestValue, specifier: "%.2f")")
                        .font(.title2)
                        .foregroundStyle(.primary)
                        .fontWeight(.bold)
                        .contentTransition(.numericText())
                        .animation(.default, value: latestValue)
                        .fontDesign(.rounded)
                }
            }
            .padding(.horizontal)

            DeviceStatisticsView(dailyAverage: dailyAverage,
                                 weekdayAverage: weekdayAverage,
                                 weekendAverage: weekendAverage,
                                 highestRecord: highestRecord)

            DeviceSystemStatusControls(deviceStatus: deviceViewModel.device.status)
                .containerBackground(containerBackground, for: .tabView)
        }
        .tabViewStyle(.verticalPage)
        .onAppear {
            loadData()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showModal = true
                } label: {
                    Label("View", systemImage: "line.3.horizontal.decrease.circle")
                }
                .sheet(isPresented: $showModal) {
                    DeviceViewOptionsModal(selectedDataType: $selectedDataType, loadData: loadData)
                }
            }
        }
        .foregroundStyle(.white)
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
