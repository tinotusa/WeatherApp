//
//  DailyWeatherResponse.swift
//  Weather
//
//  Created by Tino on 10/12/21.
//

import Foundation

struct Coordinates: Codable, Equatable {
    let lon: Double
    let lat: Double
}

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
    let icon: String
}

struct WeatherItem: Codable, Identifiable {
    let id = UUID()
    let date: Date
    let sunrise: Date
    let sunset: Date
    let temp: Temperature
    let pressure: Double
    let humidity: Double
    let description: [WeatherDescription]
    let windSpeed: Double
    let windDeg: Int
    let clouds: Int
    let rainVolume: Double? // in mm
    let chanceOfRain: Double
    
    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case description = "weather"
        case chanceOfRain = "pop"
        case rainVolume = "rain"
        case sunrise, sunset, temp, pressure, humidity, clouds
    }
    
    var dayTemp: String {
        formatTemp(temp.day)
    }
    
    var iconID: Int {
        description.first!.id
    }
}

struct HourlyItem: Codable, Hashable, Equatable, Identifiable {
    struct WeatherItem: Codable, Hashable {
        let id: Int
    }
    
    let id = UUID()
    let date: Date
    let temp: Double
    let weather: [WeatherItem]
    
    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case temp, weather
    }
    
    var iconID: Int {
        weather.first!.id
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let dateComponenets = Calendar.current.dateComponents([.hour], from: date)
        let currentCompoenets = Calendar.current.dateComponents([.hour], from: Date())
        if let dateHour = dateComponenets.hour, let currentHour = currentCompoenets.hour,
           dateHour == currentHour {
            return "Now"
        }
        return formatter.string(from: date)
    }
    
}

struct WeatherAlert: Codable {
    let senderName: String
    let event: String
    let start: Date
    let end: Date
    let description: String
    let tags: [String]
    
    enum CodingKeys: String, CodingKey {
        case senderName = "sender_name"
        case event, start, end, description, tags
    }
}

class DailyWeatherResponse: NSObject, Codable, Identifiable {
    let id = UUID()
    var place: GeoResponse?
    
    // this is not in CodingKeys because i want to load a new image
    // each time the app is launched
    var _unsplashedPhoto: UnsplashedPhoto?
    
    let lat: Double
    let lon: Double
    let timezone_offset: Double
    let daily: [WeatherItem]
    let hourly: [HourlyItem]
    let alerts: [WeatherAlert]?
    
    enum CodingKeys: CodingKey {
        case lat, lon, daily, place, hourly, alerts, timezone_offset
    }
    
    var coord: Coordinates {
        Coordinates(lon: lon, lat: lat)
    }
    
    var unsplashedPhoto: UnsplashedPhoto? {
        get { _unsplashedPhoto }
        set { _unsplashedPhoto = newValue }
    }
    
    var fullName: String {
        if let place = place {
            return place.text
        } 
        return "N/A"
    }
    
    var name: String {
        if let place = place {
            return place.name
        }
        return "N/A"
    }
    
    var nextTwelveHours: [HourlyItem] {
        var hours = [HourlyItem]()
        for i in 0 ..< 12 where i < hourly.count {
            hours.append(hourly[i])
        }
        
        return hours
    }
    
    static func ==(_ lhs: DailyWeatherResponse, _ rhs: DailyWeatherResponse) -> Bool {
        lhs.id == rhs.id
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
    ],
    "hourly": [
        {
          "dt": 1618315200,
          "temp": 282.58,
          "feels_like": 280.4,
          "pressure": 1019,
          "humidity": 68,
          "dew_point": 276.98,
          "uvi": 1.4,
          "clouds": 19,
          "visibility": 306,
          "wind_speed": 4.12,
          "wind_deg": 296,
          "wind_gust": 7.33,
          "weather": [
            {
              "id": 801,
              "main": "Clouds",
              "description": "few clouds",
              "icon": "02d"
            }
          ],
          "pop": 0
        },
        {
          "dt": 1618315200,
          "temp": 282.58,
          "feels_like": 280.4,
          "pressure": 1019,
          "humidity": 68,
          "dew_point": 276.98,
          "uvi": 1.4,
          "clouds": 19,
          "visibility": 306,
          "wind_speed": 4.12,
          "wind_deg": 296,
          "wind_gust": 7.33,
          "weather": [
            {
              "id": 801,
              "main": "Clouds",
              "description": "few clouds",
              "icon": "02d"
            }
          ],
          "pop": 0
        },
        {
          "dt": 1618315200,
          "temp": 282.58,
          "feels_like": 280.4,
          "pressure": 1019,
          "humidity": 68,
          "dew_point": 276.98,
          "uvi": 1.4,
          "clouds": 19,
          "visibility": 306,
          "wind_speed": 4.12,
          "wind_deg": 296,
          "wind_gust": 7.33,
          "weather": [
            {
              "id": 801,
              "main": "Clouds",
              "description": "few clouds",
              "icon": "02d"
            }
          ],
          "pop": 0
        }
    ]
}
"""
        let data = text.data(using: .utf8)!
        return try! JSONDecoder().decode(DailyWeatherResponse.self, from: data)
    }
}

// MARK: - functions for alerts
extension DailyWeatherResponse {
    var hasAlert: Bool {
        alerts != nil
    }
    
    var weatherAlert: WeatherAlert? {
        alerts?.first
    }
    
    var alertStartDate: Date? {
        weatherAlert?.start
    }
    
    var alertEndDate: Date? {
        weatherAlert?.end
    }
    
    var alertSenderName: String? {
        weatherAlert?.senderName
    }
    
    var alertEvent: String? {
        weatherAlert?.event
    }
    
    private func alertDateFormatter(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    var formattedAlertStartDate: String {
        alertDateFormatter(alertStartDate ?? Date())
    }
    
    var formattedAlertEndDate: String {
        alertDateFormatter(alertEndDate ?? Date())
    }
}

// MARK: - Functions for the current day
extension DailyWeatherResponse {
    var current: WeatherItem {
        daily.first!
    }
    
    var iconID: Int {
        current.description.first!.id
    }
    
    var temp: String {
        formatTemp(current.temp.day)
    }
    
    var minTemp: String {
        formatTemp(current.temp.min)
    }
    
    var maxTemp: String {
        formatTemp(current.temp.max)
    }
    
    private func dateFormatter(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var sunrise: String {
        dateFormatter(current.sunrise)
    }
    
    var sunset: String {
        dateFormatter(current.sunset)
    }
    
    var windSpeed: String {
        if Locale.current.usesMetricSystem {
            return String(format: "%g m/s", current.windSpeed)
        }
        return String(format: "%g mph", current.windSpeed)
    }
    
    var windDeg: String {
        return String(format: "%dº", current.windDeg)
    }
    
    var pop: String {
        String(format: "%g%%", current.chanceOfRain * 100.0)
    }
    
    var rainVolume: String {
        String(format: "%.0fmm", current.rainVolume ?? 0)
    }
    
    var humidity: String {
        String(format: "%g%%", current.humidity)
    }
    
    var weatherDescription: String {
        current.description.first!.description
    }
}
