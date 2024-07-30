//
//  AquaGuard2App.swift
//  AquaGuard2
//
//  Created by Tristan Listanco on 7/29/24.
//

import SwiftUI
import TipKit

@main
struct AquaGuard2App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    // Configure and load your tips at app launch.
                    do {
                        try Tips.configure([
                            .displayFrequency(.immediate),
                            .datastoreLocation(.applicationDefault)
                        ])
                        try? Tips.resetDatastore()
                    }
                    catch {
                        // Handle TipKit errors
                        print("Error initializing TipKit \(error.localizedDescription)")
                    }
                }
        }
    }
}
