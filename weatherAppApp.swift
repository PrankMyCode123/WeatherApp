//
//  weatherAppApp.swift
//  weatherApp
//
//  Created by Đinh Trung Quốc Anh on 9/11/24.
//

import SwiftUI

@main
struct weatherAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            WeatherListScreen().environmentObject(Store())
        }
    }
}
