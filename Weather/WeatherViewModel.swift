//
//  HomeViewModel.swift
//  Weather
//
//  Created by Tino on 29/11/21.
//

import SwiftUI


final class WeatherViewModel: ObservableObject {
    @Published var weatherModel = WeatherModel()
    
    var locations: [GeoResponse] {
        get { weatherModel.locations }
        set { weatherModel.locations = newValue }
    }
    
    var currentWeather: [WeatherResponse] {
        weatherModel.currentWeather
    }
    
    var dailyWeather: [DailyWeatherResponse] {
        weatherModel.dailyWeather
    }
    
    var hasLocations: Bool {
        !weatherModel.locations.isEmpty
    }
    
    var suggestions: [GeoResponse] {
        weatherModel.suggestions
    }
    
    var isLoading: Bool {
        weatherModel.isLoading == true
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
    func addLocation(_ location: GeoResponse) async {
        weatherModel.addLocation(location)
//        await weatherModel.loadCurrentWeather()
        await weatherModel.loadDailyWeather()
    }
    
    func removeWeather(_ weather: WeatherResponse) {
        weatherModel.removeWeather(weather)
    }
    func removeWeather(named location: String) {
        weatherModel.removeWeather(named: location)
    }
    
    @MainActor
    func loadDailyWeather() async {
        await weatherModel.loadDailyWeather()
    }
    
    @MainActor
    func searchAPI(for searchTerm: String) async {
        await weatherModel.searchAPI(for: searchTerm)
    }
    
    func getName(for location: Coordinates) -> String {
        weatherModel.getName(for: location)
    }
}
