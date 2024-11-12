//
//  WidgetWeather.swift
//  WidgetWeather
//
//  Created by Phương An on 11/11/2024.
//

import SwiftUI
import Foundation
import WidgetKit

@main
struct WeatherWidget: Widget {
    let kind: String = "WeatherWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Widget_Provider()) { (entry: Widget_WeatherEntry) in
            WeatherWidgetEntryView(entry: entry)
                .environmentObject(Store()) // Pass the environment object
        }
        .configurationDisplayName("Weather Widget")
        .description("Shows current weather for a specific city added by the user.")
        .supportedFamilies([.systemMedium])
    }
}
struct WeatherWidget_Previews: PreviewProvider {
    static var previews: some View {
        WeatherWidgetEntryView(entry: Widget_WeatherEntry(date: Date(), weather: WeatherViewModel(weather: Weather(city: "San Francisco", temperature: 68, icon: "01d", sunrise: Date(), sunset: Date()))))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
