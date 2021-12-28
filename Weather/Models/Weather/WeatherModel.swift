//
//  WeatherModel.swift
//  Weather
//
//  Created by Tino on 4/12/21.
//

import Foundation

struct WeatherModel {
    var suggestions = [GeoResponse]()
    var weather = [DailyWeatherResponse]()
    
    mutating func addLocation(_ location: DailyWeatherResponse) {
        if weather.contains(location) {
           return
        }
        weather.append(location)
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
            weather = try JSONDecoder().decode([DailyWeatherResponse].self, from: data)
        } catch {
            print("Error: \(#function) Failed to load locations.\n\(weather)")
        }
    }
    
    private static let saveFilename = "Weatherlocations"
    func save() {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let saveURL = documents.appendingPathComponent(Self.saveFilename)
        do {
            let data = try JSONEncoder().encode(weather)
            try data.write(to: saveURL, options: [.atomic, .completeFileProtection])
        } catch {
            print("Error: \(#function) failed to save locations.\n\(error)")
        }
    }
    
    mutating func removeWeather(_ weather: DailyWeatherResponse) {
        guard let index = self.weather.firstIndex(where: { $0 == weather }) else {
            return
        }
        self.weather.remove(at: index)
        save()
    }
    
    mutating func loadWeather() async {
        for (i, weather) in weather.enumerated() {
            guard let temp = await NetworkManager.loadDailyWeather(for: weather.coord, place: weather.place!) else {
                continue
            }
            self.weather[i] = temp
        }
    }
}