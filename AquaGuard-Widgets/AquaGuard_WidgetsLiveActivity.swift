//
//  AquaGuard_WidgetsLiveActivity.swift
//  AquaGuard-Widgets
//
//  Created by Tristan Listanco on 8/2/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct AquaGuard_WidgetsAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct AquaGuard_WidgetsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: AquaGuard_WidgetsAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension AquaGuard_WidgetsAttributes {
    fileprivate static var preview: AquaGuard_WidgetsAttributes {
        AquaGuard_WidgetsAttributes(name: "World")
    }
}

extension AquaGuard_WidgetsAttributes.ContentState {
    fileprivate static var smiley: AquaGuard_WidgetsAttributes.ContentState {
        AquaGuard_WidgetsAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: AquaGuard_WidgetsAttributes.ContentState {
         AquaGuard_WidgetsAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: AquaGuard_WidgetsAttributes.preview) {
   AquaGuard_WidgetsLiveActivity()
} contentStates: {
    AquaGuard_WidgetsAttributes.ContentState.smiley
    AquaGuard_WidgetsAttributes.ContentState.starEyes
}
