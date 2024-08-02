//
//  AddDevicePopoverView.swift
//  AquaGuard2
//
//  Created by Tristan Listanco on 8/2/24.
//

import SwiftUI

#if os(iOS)
struct AddDataPopoverView: View {
    @Binding var isPopoverPresented: Bool
    @Binding var newDate: Date
    @Binding var newTime: Date
    @Binding var newValue: String
    var addDataAction: () -> Void

    var body: some View {
        NavigationView {
            Form {
                Section {
                    DatePicker("Date", selection: $newDate, displayedComponents: .date)
                    DatePicker("Time", selection: $newTime, displayedComponents: .hourAndMinute)
                    TextField("Enter value", text: $newValue)
                }
            }
            .navigationTitle("Add Data")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPopoverPresented = false
                },
                trailing: Button("Add") {
                    addDataAction()
                }
            )
        }
    }
}

#elseif os(macOS)
struct AddDataPopoverView: View {
    @Binding var isPopoverPresented: Bool
    @Binding var newDate: Date
    @Binding var newTime: Date
    @Binding var newValue: String
    var addDataAction: () -> Void

    var body: some View {
        Form {
            Section("Add Data") {
                DatePicker("Date", selection: $newDate, displayedComponents: .date)
                DatePicker("Time", selection: $newTime, displayedComponents: .hourAndMinute)
                TextField("Enter value", text: $newValue)
            }
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    isPopoverPresented = false
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Add") {
                    addDataAction()
                }
            }
        }
    }
}
#endif
