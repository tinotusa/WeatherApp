//
//  WeatherModel.swift
//  Weather
//
//  Created by Tino on 4/12/21.
//

import Foundation

struct WeatherModel {
    var locations = [GeoResponse]()
    var suggestions = [GeoResponse]()
    var currentWeather = [WeatherResponse]()
    var dailyWeather = [DailyWeatherResponse]()
    var isLoading = false
    
    mutating func addLocation(_ location: GeoResponse) {
        if locations.contains(location) {
           return
        }
        locations.append(location)
        save()
    }
    
    mutating func searchAPI(for searchTerm: String) async {
        isLoading = true
        suggestions = await NetworkManager.loadSuggestions(for: searchTerm)
        isLoading = false
    }
    
    mutating func load() {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let saveURL = documents.appendingPathComponent(Self.saveFilename)
        do {
            let data = try Data(contentsOf: saveURL)
            locations = try JSONDecoder().decode([GeoResponse].self, from: data)
        } catch {
            print("Error: \(#function) Failed to load locations.\n\(locations)")
        }
    }
    
    private static let saveFilename = "Weatherlocations"
    func save() {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let saveURL = documents.appendingPathComponent(Self.saveFilename)
        do {
            let data = try JSONEncoder().encode(locations)
            try data.write(to: saveURL, options: [.atomic, .completeFileProtection])
        } catch {
            print("Error: \(#function) failed to save locations.\n\(error)")
        }
    }
    
    mutating func loadDailyWeather() async {
        dailyWeather = []
        for location in locations {
            guard let weather = await NetworkManager.loadDailyWeather(for: location.coord) else {
                continue
            }
            dailyWeather.append(weather)
        }
    }
    
    mutating func removeWeather(named location: String) {
        guard let index = locations.firstIndex(where: { $0.name == location }) else {
            return
        }
        locations.remove(at: index)
        save()
    }
    
    mutating func removeWeather(_ weather: WeatherResponse) {
        guard let index = locations.firstIndex(where: { $0.name == weather.name }) else {
            return
        }
        locations.remove(at: index)
        save()
    }
    
    func getName(for location: Coordinates) -> String {
        guard let item = locations.first(where: { $0.coord == location }) else {
            return "N/A"
        }
        return item.name
    }
}
