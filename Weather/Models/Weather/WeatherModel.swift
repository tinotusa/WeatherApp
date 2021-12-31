//
//  WeatherModel.swift
//  Weather
//
//  Created by Tino on 4/12/21.
//

import Foundation

struct WeatherModel {
    var suggestions = [GeoResponse]()
    var weatherLocations = [DailyWeatherResponse]()
    
    mutating func addLocation(_ location: DailyWeatherResponse) {
        if weatherLocations.contains(location) {
           return
        }
        weatherLocations.append(location)
        save()
    }
    
    mutating func searchAPI(for searchTerm: String) async {
        suggestions = await NetworkManager.loadSuggestions(for: searchTerm)
    }
    
    mutating func load() {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let saveURL = documents.appendingPathComponent(Self.saveFilename)
        do {
            let data = try Data(contentsOf: saveURL)
            weatherLocations = try JSONDecoder().decode([DailyWeatherResponse].self, from: data)
        } catch {
            print("Error: \(#function) Failed to load locations.\n\(weatherLocations)")
        }
    }
    
    private static let saveFilename = "Weatherlocations"
    func save() {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let saveURL = documents.appendingPathComponent(Self.saveFilename)
        do {
            let data = try JSONEncoder().encode(weatherLocations)
            try data.write(to: saveURL, options: [.atomic, .completeFileProtection])
        } catch {
            print("Error: \(#function) failed to save locations.\n\(error)")
        }
    }
    
    mutating func removeWeather(_ weather: DailyWeatherResponse) {
        guard let index = self.weatherLocations.firstIndex(where: { $0 == weather }) else {
            return
        }
        self.weatherLocations.remove(at: index)
        save()
    }
    
    mutating func loadWeather() async {
        for (i, weather) in weatherLocations.enumerated() {
            guard let temp = await NetworkManager.loadDailyWeather(for: weather.coord, place: weather.place!) else {
                continue
            }
            self.weatherLocations[i] = temp
        }
    }
}
