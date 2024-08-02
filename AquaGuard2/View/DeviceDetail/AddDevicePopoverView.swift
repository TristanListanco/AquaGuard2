//
//  AddDevicePopoverView.swift
//  AquaGuard2
//
//  Created by Tristan Listanco on 8/2/24.
//

import SwiftUI

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
            .navigationTitle("Add Data") // Adjust as needed
            .navigationBarTitleDisplayMode(.inline) // This sets the navigation bar title to use the inline style
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
