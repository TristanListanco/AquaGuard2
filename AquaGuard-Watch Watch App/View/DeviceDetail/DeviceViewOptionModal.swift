//
//  DeviceViewOptionModal.swift
//  AquaGuard-Watch Watch App
//
//  Created by Tristan Listanco on 8/3/24.
//

import SwiftUI

struct DeviceViewOptionsModal: View {
    @Binding var selectedDataType: DataType
    let loadData: () -> Void
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        // Options list
        List {
            ForEach(DataType.allCases, id: \.self) { type in
                HStack {
                    Label(type.rawValue, systemImage: type.iconName)
                        .foregroundStyle(Color.white)
                    Spacer()
                    if selectedDataType == type {
                        Image(systemName: "checkmark")
                    }
                }
                .contentShape(Rectangle()) // Make the entire row tappable
                .onTapGesture {
                    selectedDataType = type
                    loadData()
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .listRowBackground(Color.white)
        .listStyle(.carousel)
    }
}

extension DataType {
    var iconName: String {
        switch self {
        case .temperature:
            return "thermometer"
        case .pH:
            return "leaf.arrow.circlepath"
        case .TDS:
            return "circle.hexagongrid"
        case .WaterFlow:
            return "water.waves.and.arrow.trianglehead.up"
        case .EC:
            return "bolt"
        case .Turbidity:
            return "atom"
        }
    }
}

// #Preview {
//    DeviceViewOptionsModal()
// }
