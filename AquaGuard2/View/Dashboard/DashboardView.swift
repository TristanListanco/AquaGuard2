//
//  DashboardView.swift
//  AquaGuard2
//
//  Created by Tristan Listanco on 7/29/24.
//
import SwiftUI

struct DashboardView: View {
    @State private var isProfileViewPresented = false
    @Namespace var namespace
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var isArticleViewPresented = false
    @State private var isAddDeviceViewPresented = false
    @State private var selectedArticle: Article?
    @State private var selectedDevice: DeviceViewModel?
    @State private var searchQuery = ""
    @State private var deviceViewModels = DeveloperPreview.shared.dummyDeviceViewModels()

    var filteredDeviceViewModels: [DeviceViewModel] {
        if searchQuery.isEmpty {
            return deviceViewModels
        } else {
            return deviceViewModels.filter {
                $0.device.name.localizedCaseInsensitiveContains(searchQuery) ||
                    $0.device.location.localizedCaseInsensitiveContains(searchQuery)
            }
        }
    }

    var body: some View {
        NavigationSplitView {
            #if os(iOS)
                List(selection: $selectedDevice) {
                    ForEach(filteredDeviceViewModels, id: \.device.id) { viewModel in
                        DeviceCard(viewModel: viewModel)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(action: {
                                    // Action for editing the device
                                    selectedDevice = viewModel
                                    isAddDeviceViewPresented = true
                                }) {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(.blue)

                                Button(role: .destructive, action: {
                                    // Action for deleting the device
                                    if let index = deviceViewModels.firstIndex(where: { $0.device.id == viewModel.device.id }) {
                                        deviceViewModels.remove(at: index)
                                    }
                                }) {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .onTapGesture {
                                selectedDevice = viewModel
                            }
                    }
                }
                .listStyle(SidebarListStyle())
                .navigationTitle("Devices")
                .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always))
            #elseif os(macOS)
                VStack {
                    TextField("Search Devices", text: $searchQuery)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    List(selection: $selectedDevice) {
                        ForEach(filteredDeviceViewModels, id: \.device.id) { viewModel in
                            DeviceCard(viewModel: viewModel)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button(action: {
                                        // Action for editing the device
                                        selectedDevice = viewModel
                                        isAddDeviceViewPresented = true
                                    }) {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    .tint(.blue)

                                    Button(role: .destructive, action: {
                                        // Action for deleting the device
                                        if let index = deviceViewModels.firstIndex(where: { $0.device.id == viewModel.device.id }) {
                                            deviceViewModels.remove(at: index)
                                        }
                                    }) {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    .listStyle(SidebarListStyle())
                    .navigationTitle("Devices")
                }
            #endif
        } detail: {
            if let selectedDevice = selectedDevice {
                DeviceDetailView(deviceViewModel: selectedDevice)
                    .onAppear {
                        Task {
                            await selectedDevice.loadData()
                        }
                    }

            } else {
                VStack {
                    Image(systemName: "drop.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .imageScale(.large)
                    Text("Select a device to View")
                        .fontDesign(.rounded)
                }
            }
        }
        .refreshable {}
        .sheet(isPresented: $isAddDeviceViewPresented) {
            NavigationView {
                AddDeviceView(isPresented: $isAddDeviceViewPresented, device: $selectedDevice)
                    .presentationSizing(.form)
                #if os(iOS)
                    .navigationBarTitleDisplayMode(.inline)
                #endif
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
