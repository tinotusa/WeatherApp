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
    
    func addLocation(_ location: GeoResponse) {
        weatherModel.addLocation(location)
    }
    
    @MainActor
    func searchAPI(for searchTerm: String) async {
        await weatherModel.searchAPI(for: searchTerm)
    }
}
