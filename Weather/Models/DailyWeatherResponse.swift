//
//  DailyWeatherResponse.swift
//  Weather
//
//  Created by Tino on 10/12/21.
//

import Foundation

//struct Coordinates: Codable, Equatable {
//    let lon: Double
//    let lat: Double
//}

// TODO: Move to own file
struct City: Codable, Identifiable {
    let id: Int
    let name: String
    let coord: Coordinates
    let country: String
    let population: Int
    let timezone: Int
}

struct Temperature: Codable {
    let day: Double
    let min: Double
    let max: Double
    let night: Double
    let eve: Double
    let morn: Double
}

struct WeatherDescription: Codable, Identifiable {
    let id: Int
    let main: String
    let description: String
    public let icon: String
}

struct WeatherItem: Codable, Identifiable {
    let id = UUID()
    let date: Date
    let sunrise: Date
    let sunset: Date
    let temp: Temperature
    let pressure: Double
    let humidity: Double
    let weather: [WeatherDescription]
    let windSpeed: Double
    let windDeg: Int
    let clouds: Int
    let rain: Double?
    let pop: Double
    
    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case sunrise, sunset, temp, pressure, humidity, weather, clouds, rain, pop
    }
    
}

struct DailyWeatherResponse: Codable, Identifiable {
    let id = UUID()
    let lat: Double
    let lon: Double
    let daily: [WeatherItem]
    
    enum CodingKeys: CodingKey {
        case daily, lat, lon
    }
    
    var coord: Coordinates {
        Coordinates(lon: lon, lat: lat)
    }
    
    static var example: DailyWeatherResponse {
        let text = """
{
    "lat": 33.44,
    "lon": -94.04,
        "daily":
        [
            {
                "dt": 1618308000,
                "sunrise": 1618282134,
                "sunset": 1618333901,
                "moonrise": 1618284960,
                "moonset": 1618339740,
                "moon_phase": 0.04,
                "temp": {
                    "day": 279.79,
                    "min": 275.09,
                    "max": 284.07,
                    "night": 275.09,
                    "eve": 279.21,
                    "morn": 278.49
                },
                "pressure": 1020,
                "humidity": 81,
                "dew_point": 276.77,
                "wind_speed": 3.06,
                "wind_deg": 294,
                "weather": [
                    {
                        "id": 500,
                        "main": "Rain",
                        "description": "light rain",
                        "icon": "10d"
                    }
                ],
                "clouds": 56,
                "pop": 0.2,
                "rain": 0.62,
                "uvi": 1.93
            }
        ]
}
"""
        let data = text.data(using: .utf8)!
        return try! JSONDecoder().decode(DailyWeatherResponse.self, from: data)
    }
}
