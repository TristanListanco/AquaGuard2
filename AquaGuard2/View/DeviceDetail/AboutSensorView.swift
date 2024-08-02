//
//  AboutSensorView.swift
//  AquaGuard2
//
//  Created by Tristan Listanco on 8/2/24.
//

import SwiftUI


struct AboutSensorView: View {
    var selectedDataType: DataType // Define a variable to hold the DataType

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("About \(selectedDataType.rawValue.capitalized)")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Step count is the number of steps you take throughout the day. Pedometers and digital activity trackers can help you determine your step count. These devices count steps for any activity that involves step-like movement, including walking, running, stair-climbing, cross-country skiing, and even movement as you go about your daily chores.")
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(UIColor.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .padding(.horizontal, 20)
    }
}

struct AboutSensorView_Previews: PreviewProvider {
    static var previews: some View {
        AboutSensorView(selectedDataType: .temperature) // Pass a default value for preview
    }
}
