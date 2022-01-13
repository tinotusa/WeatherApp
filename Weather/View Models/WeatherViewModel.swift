//
//  HomeViewModel.swift
//  Weather
//
//  Created by Tino on 29/11/21.
//

import SwiftUI


final class WeatherViewModel: ObservableObject {
    @Published var weatherModel = WeatherModel()
    @Published var isLoading = false
    
    var weather: [DailyWeatherResponse] {
        get { weatherModel.weatherLocations }
        set { weatherModel.weatherLocations = newValue }
    }
    
    var hasWeatherItems: Bool {
        !weatherModel.weatherLocations.isEmpty
    }
    var suggestions: [GeoResponse] {
        weatherModel.suggestions
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
    func addUserLocation(_ locationManager: LocationManager) async {
        if locationManager.lastLocation != nil {
            let coords = Coordinates(
                lon: locationManager.lastLocation!.coordinate.longitude,
                lat: locationManager.lastLocation!.coordinate.latitude
            )
            guard let place = await NetworkManager.loadPlace(lon: coords.lon, lat: coords.lat) else { return }
            guard let weatherResponse = await NetworkManager.loadDailyWeather(for: coords, place: place.convertToGeoResponse()) else { return }
            if !weather.contains(where: {$0.place?.cityID == place.id }) {
                weather.insert(weatherResponse, at: 0)
                save()
            }
        }
    }
    
    @MainActor
    func addLocationFromSuggestion(coords: Coordinates, place: GeoResponse) async {
        await weatherModel.addLocationFromSuggestion(coords: coords, place: place)
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
        isLoading = true
        defer { isLoading = false }
        await weatherModel.searchAPI(for: searchTerm)
    }

    @MainActor
    func loadWeather() async {
        isLoading = true
        defer { isLoading = false }
        await weatherModel.loadWeather()
    }
}
