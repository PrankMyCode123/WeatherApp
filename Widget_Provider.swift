//
//  Widget_Provider.swift
//  midApp
//
//  Created by Phương An on 12/11/2024.
//
import WidgetKit
import SwiftUI

struct Widget_Provider: TimelineProvider {
    @EnvironmentObject var store : Store
    let fetcher = WeatherFetcher()
    
    // Retrieve the last city from UserDefaults; if nil, display "No City Found"
    var lastCity: String? {
        UserDefaults.standard.string(forKey: "lastCity")
    }
    
    func placeholder(in context: Context) -> Widget_WeatherEntry {
        // If no city is found, show placeholder with "No City Found"
        let city = lastCity ?? "No City Found"
        return Widget_WeatherEntry(date: Date(), weather: WeatherViewModel(weather: Weather(city: city, temperature: 0, icon: "01d", sunrise: Date(), sunset: Date())))
    }

    func getSnapshot(in context: Context, completion: @escaping (Widget_WeatherEntry) -> Void) {
        // If no city is found, show a "No City Found" entry
        guard let city = lastCity else {
            let noCityWeather = WeatherViewModel(weather: Weather(city: "No City Found", temperature: 0, icon: "01d", sunrise: Date(), sunset: Date()))
            completion(Widget_WeatherEntry(date: Date(), weather: noCityWeather))
            return
        }
        
        // Fetch weather data for the last added city
        fetchWeather(for: city, completion: completion)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Widget_WeatherEntry>) -> Void) {
        // If no city is found, create a timeline with "No City Found" entry
        guard let city = lastCity else {
            let noCityWeather = WeatherViewModel(weather: Weather(city: "No City Found", temperature: 0, icon: "01d", sunrise: Date(), sunset: Date()))
            let entry = Widget_WeatherEntry(date: Date(), weather: noCityWeather)
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
            return
        }
        
        // Fetch the weather data based on the last added city
        fetchWeather(for: city) { entry in
            let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(3600)))
            completion(timeline)
        }
    }
    
    private func fetchWeather(for city: String, completion: @escaping (Widget_WeatherEntry) -> Void) {
        fetcher.fetchWeather(for: city) { weather in
            guard let weather = weather else {
                // If fetching fails, show "No City Found" entry as fallback
                let fallbackWeather = WeatherViewModel(weather: Weather(city: "No City Found", temperature: 0, icon: "01d", sunrise: Date(), sunset: Date()))
                completion(Widget_WeatherEntry(date: Date(), weather: fallbackWeather))
                return
            }
            
            // Prepare the fetched weather data entry
            let updatedWeather = WeatherViewModel(weather: Weather(
                city: weather.city,
                temperature: weather.getTemperatureByUnit(unit: store.selectedUnit),
                icon: weather.icon,
                sunrise: weather.sunrise,
                sunset: weather.sunset
            ))
            
            completion(Widget_WeatherEntry(date: Date(), weather: updatedWeather))
        }
    }
}
