//
//  AquaGuard_WidgetsBundle.swift
//  AquaGuard-Widgets
//
//  Created by Tristan Listanco on 8/2/24.
//

import WidgetKit
import SwiftUI

@main
struct AquaGuard_WidgetsBundle: WidgetBundle {
    var body: some Widget {
        AquaGuard_Widgets()
        AquaGuard_WidgetsControl()
        AquaGuard_WidgetsLiveActivity()
    }
}
