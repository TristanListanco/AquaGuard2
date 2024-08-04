//
//  MainTabView.swift
//  AquaGuard-Watch Watch App
//
//  Created by Tristan Listanco on 8/3/24.
//
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .containerBackground(Color.accentColor.gradient, for: .tabView)
        }
    }
}

#Preview {
    MainTabView()
}
