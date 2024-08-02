//
//  AquaGuard_Widgets.swift
//  AquaGuard-Widgets
//
//  Created by Tristan Listanco on 8/2/24.
//

import SwiftUI
import WidgetKit

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct AquaGuard_WidgetsEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(.white)
                        .opacity(0.6)
                    VStack(alignment: .leading, spacing: 0) {
                        Text("HOUSEHOLD VILLAGE #1")
                            .font(.system(size: 10, weight: .semibold, design: .default))
                            .foregroundColor(.white)
                            .opacity(0.6)
                    }
                }
                Spacer()
                HStack {
                    Text("20 ppm")
                        .font(.system(size: 30, weight: .medium, design: .rounded))
                        .foregroundColor(.white)
                    Spacer()
                }
                HStack {
                    Image(systemName: "bolt.fill")
                        .foregroundColor(.white)
                        .opacity(0.6)
                    Text("ELECTRIC CONDUCTIVITY")
                        .font(.system(size: 10, weight: .bold, design: .default))
                        .foregroundColor(.white)
                        .opacity(0.6)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // << this one !!
        }
        .edgesIgnoringSafeArea(.all) // Ensures the gradient fills the entire view.
        .frame(maxWidth: .infinity, maxHeight: .infinity) // << this one !!
        .widgetURL(URL(string: "your-url-here")) // Optional: Handle tap to open URL
    }
}

struct AquaGuard_Widgets: Widget {
    let kind: String = "AquaGuard_Widgets"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            AquaGuard_WidgetsEntryView(entry: entry)
                .containerBackground(LinearGradient(gradient: Gradient(colors: [Color(red: 94/255, green: 218/255, blue: 245/255), Color.accentColor]), startPoint: .top, endPoint: .bottom), for: .widget)
        }
        .configurationDisplayName("Select a Widget")
        .description("Monitor water quality and environmental data with AquaGuard")
    }
}

private extension ConfigurationAppIntent {
    static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }

    static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemMedium) {
    AquaGuard_Widgets()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
