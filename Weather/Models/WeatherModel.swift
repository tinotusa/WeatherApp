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
    var isLoading = false
    
    mutating func addLocation(_ location: GeoResponse) {
        if locations.contains(location) {
           return
        }
        locations.append(location)
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
            print("Error: Failed to load locations.\n\(locations)")
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
            print("Error: failed to save locations.\n\(error)")
        }
    }
}
