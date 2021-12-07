//
//  WeatherResponse.swift
//  Weather
//
//  Created by Tino on 7/12/21.
//

import Foundation

struct Coordinates: Codable {
    let lon: Double
    let lat: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct MainWeather: Codable {
    let temp: Double
    let pressure: Int
    let humidity: Int
    let tempMin: Double
    let tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

struct System: Codable {
    let type: Int
    let id: Int
    let message: Double?
    let country: String
    let sunrise: Date
    let sunset: Date
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
}

struct WeatherResponse: Codable {
    let id: Int
    let name: String
    let cod: Int
    let dt: Date
    let visibility: Int
    let base: String
    let coordinates: Coordinates
    let wind: Wind
    let weather: [Weather]
    let main: MainWeather
    let system: System
    
    enum CodingKeys: String, CodingKey {
        case id, name, cod, dt, visibility, base, wind, weather, main
        case coordinates = "coord"
        case system = "sys"
    }
    
    static var invalidResponse: WeatherResponse {
        return .init(
            id: 1,
            name: "Not Found",
            cod: 1,
            dt: Date(),
            visibility: 1,
            base: "Not Found",
            coordinates: .init(lon: 1, lat: 1),
            wind: Wind(speed: 1, deg: 1),
            weather: [],
            main: MainWeather(
                temp: 1,
                pressure: 1,
                humidity: 1,
                tempMin: 1,
                tempMax: 1
            ),
            system: System(
                type: 1,
                id: 1,
                message: 1,
                country: "Not Found",
                sunrise: Date(),
                sunset: Date()
            )
        )
    }
}
