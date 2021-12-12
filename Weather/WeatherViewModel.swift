//
//  HomeViewModel.swift
//  Weather
//
//  Created by Tino on 29/11/21.
//

import SwiftUI


final class WeatherViewModel: ObservableObject {
    @Published var weatherModel = WeatherModel()
    
    var dailyWeather: [DailyWeatherResponse] {
        get { weatherModel.weather }
        set { weatherModel.weather = newValue }
    }
    
    var hasWeatherItems: Bool {
        !weatherModel.weather.isEmpty
    }
    var suggestions: [GeoResponse] {
        weatherModel.suggestions
    }
    
    var isLoading: Bool {
        weatherModel.isLoading
    }
    
    init() {
        load()
    }
    
    private func load() {
        weatherModel.load()
    }
    
    func save() {
        weatherModel.save()
    }
    
    @MainActor
    func addLocation(_ weather: DailyWeatherResponse) async {
        weatherModel.addLocation(weather)
    }
    
    func removeWeather(_ weather: DailyWeatherResponse) {
        weatherModel.removeWeather(weather)
    }
    
    @MainActor
    func searchAPI(for searchTerm: String) async {
        await weatherModel.searchAPI(for: searchTerm)
    }

    @MainActor
    func loadWeather() async {
        await weatherModel.loadWeather()
    }
}
