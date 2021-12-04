//
//  WeatherApp.swift
//  Weather
//
//  Created by Tino on 29/11/21.
//

import SwiftUI

@main
struct WeatherApp: App {
    private var weatherViewModel = WeatherViewModel()
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(weatherViewModel)
        }
    }
}
