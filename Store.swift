//
//  Store.swift
//  weatherApp
//
//  Created by Đinh Trung Quốc Anh on 9/11/24.
//

import Foundation

class Store: ObservableObject {
    
    @Published var selectedUnit: TemperatureUnit = .kelvin
    @Published var weatherList: [WeatherViewModel] = [WeatherViewModel]()
    
    func addWeather(_ weather: WeatherViewModel) {
        weatherList.append(weather)
    }
    
}
