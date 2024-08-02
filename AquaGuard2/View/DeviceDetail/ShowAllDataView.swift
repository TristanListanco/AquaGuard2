//
//  ShowAllDataView.swift
//  AquaGuard2
//
//  Created by Tristan Listanco on 8/2/24.
//

import SwiftUI

struct ShowAllDataView: View {
    var body: some View {
        List {
            NavigationLink(destination: Text("All Data View")) {
                Text("Show All Data")
            }
            NavigationLink(destination: Text("Data Sources & Access View")) {
                Text("Data Sources & Access")
            }
        }
        .navigationTitle("Settings")
        .listStyle(GroupedListStyle()) //
    }
}

#Preview {
    ShowAllDataView()
}
