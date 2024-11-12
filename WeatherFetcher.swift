//
//  WeatherFetcher.swift
//  midApp
//
//  Created by Phương An on 12/11/2024.
//

import Foundation

class WeatherFetcher {
    func fetchWeather(for city: String, completion: @escaping (WeatherViewModel?) -> Void) {
        guard let url = Constants.Urls.weatherByCity(city: city) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let weatherResponse = try JSONDecoder().decode(Widget_WeatherResponse.self, from: data)
                
                // Convert response to WeatherViewModel
                let weather = Weather(
                    city: weatherResponse.name,
                    temperature: weatherResponse.main.temp,
                    icon: weatherResponse.weather.first?.icon ?? "",
                    sunrise: Date(timeIntervalSince1970: weatherResponse.sys.sunrise),
                    sunset: Date(timeIntervalSince1970: weatherResponse.sys.sunset)
                )
                
                let viewModel = WeatherViewModel(weather: weather)
                completion(viewModel)
                
            } catch {
                print("Failed to decode JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
