//
//  UserDefaults+Extensions.swift
//  weatherApp
//
//  Created by Phương An on 08/11/2024.
//

import Foundation
extension UserDefaults {
    var unit : TemperatureUnit {
        guard let value = self.value(forKey: "unit") as? String else {
            return .kelvin
        }
        return TemperatureUnit(rawValue: value) ?? .kelvin
    }
}
