//
//  WeatherWidget.swift
//  WeatherWidget
//
//  Created by Phương An on 13/11/2024.
//

import SwiftUI
import WidgetKit
import WeatherShared
struct WeatherWidget: Widget {
    let kind: String = "WeatherWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WeatherProvider()) { entry in
            WeatherWidgetEntryView(weather:entry.weather, entry: entry)
                .environmentObject(Store.shared)
        }
        .configurationDisplayName("Weather Widget")
        .description("Shows the current weather for a selected city.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct WeatherWidget_Previews: PreviewProvider {
    static var previews: some View {
        WeatherWidgetEntryView(
            weather: WeatherViewModel(
                weather: Weather(
                    city: "Preview City",
                    temperature: 298.15,
                    icon: "01d",
                    sunrise: Date(),
                    sunset: Date()
                )
            ), entry: WeatherEntry(
                date: Date(),
                weather: WeatherViewModel(
                    weather: Weather(
                        city: "Preview City",
                        temperature: 298.15,
                        icon: "01d",
                        sunrise: Date(),
                        sunset: Date()
                    )
                )
            )
        )
        .previewContext(WidgetPreviewContext(family: .systemMedium))
        .environmentObject(Store.shared) // Add Store as environment object
    }
}



// MARK: - Weather Provider

struct WeatherProvider: TimelineProvider {
    func placeholder(in context: Context) -> WeatherEntry {
        WeatherEntry(date: Date(), weather: WeatherViewModel(weather: Weather(city: "Placeholder City", temperature: 298.15, icon: "01d", sunrise: Date(), sunset: Date())))
    }

    func getSnapshot(in context: Context, completion: @escaping (WeatherEntry) -> Void) {
        let entry = WeatherEntry(date: Date(), weather: WeatherViewModel(weather: Weather(city: "Snapshot City", temperature: 298.15, icon: "01d", sunrise: Date(), sunset: Date())))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WeatherEntry>) -> Void) {
        let weatherFetcher = WeatherFetcher()
        let city = "Your Default City" // Set a default city or retrieve from UserDefaults
        
        weatherFetcher.fetchWeather(for: city) { weatherViewModel in
            let entry = WeatherEntry(date: Date(), weather: weatherViewModel ?? WeatherViewModel(weather: Weather(city: "No Data", temperature: 0, icon: "01d", sunrise: Date(), sunset: Date())))
            
            let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(3600)))
            completion(timeline)
        }
    }
}

// MARK: - Weather Entry

struct WeatherEntry: TimelineEntry {
    let date: Date
    let weather: WeatherViewModel
}

// MARK: - Weather Widget Entry View

struct WeatherWidgetEntryView: View {
    @EnvironmentObject var store : Store
    var weather :WeatherViewModel
    var entry: WeatherProvider.Entry
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(entry.weather.city)
                    .font(.headline)
                    .bold()
                
                HStack {
                    Image(systemName: "sunrise.fill")
                    Text(entry.weather.sunrise.formatAsString())
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                
                Text("\(Int(weather.getTemperatureByUnit(unit: store.selectedUnit)))\(String(store.selectedUnit.displayText.prefix(1)))")
                    .font(.title)
                    .bold()
            }
            Spacer()
            
            // Display weather icon
            if let iconURL = URL(string: Constants.Urls.weatherURLAsStringByIcon(icon: entry.weather.icon)) {
                AsyncImage(url: iconURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                } placeholder: {
                    ProgressView()
                }
            }
        }
        .padding()
        .background(Color(red: 0.913, green: 0.934, blue: 0.981))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
