//
//  Wdiget_WeatherResponse.swift
//  midApp
//
//  Created by Phương An on 12/11/2024.
//

import Foundation

struct Widget_WeatherResponse: Decodable {
    let main: Main
    let weather: [WeatherData]
    let name: String
    let sys: Sys
    
    struct Main: Decodable {
        let temp: Double
    }
    
    struct WeatherData: Decodable {
        let icon: String
    }
    
    struct Sys: Decodable {
        let sunrise: TimeInterval
        let sunset: TimeInterval
    }
}
