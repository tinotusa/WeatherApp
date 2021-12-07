//
//  NetworkManager.swift
//  Weather
//
//  Created by Tino on 4/12/21.
//

import Foundation
import SwiftUI

struct NetworkManager {
    static func loadSuggestions(for place: String) async -> [GeoResponse] {
        var responses: [GeoResponse] = []
        guard var urlComponents = URLComponents(string: Constants.baseGeoURL) else {
            fatalError("Failed to construct URL from string: \(Constants.baseGeoURL)")
        }

        let parameters = [
            "q": place,
            "appid": Constants.weatherAPIKey,
            "limit": "15"
        ]
        let queries = parameters.map { URLQueryItem(name: $0, value: $1) }
        urlComponents.queryItems = queries

        do {
            let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
            guard (200 ..< 299).contains((response as! HTTPURLResponse).statusCode) else {
                print("Invalid response from server")
                return responses
            }
            responses = try JSONDecoder().decode([GeoResponse].self, from: data)
            return responses
        } catch {
            print("Failed to get data from \(Constants.baseGeoURL).\n\(error)")
        }

        return responses
    }
    
    static func loadCurrentWeather(for place: String) async -> WeatherResponse {
        var weatherResponse = WeatherResponse.invalidResponse
        
        // url
        guard var urlComponents = URLComponents(string: Constants.baseWeatherURL) else {
            fatalError("Failed to construct URL from string: \(Constants.baseWeatherURL)")
        }

        let urlParameters = [
            "q": place,
            "appid": Constants.weatherAPIKey,
            "units": Locale.current.usesMetricSystem ? "metric" : "imperial",
            "lang": Locale.current.languageCode ?? "en"
        ]
        
        let queries = urlParameters.map { param, value in
            URLQueryItem(name: param, value: value)
        }
        
        urlComponents.queryItems = queries
        // load data
        do {
            let request = URLRequest(url: urlComponents.url!)
            let (data, response) = try await URLSession.shared.data(for: request)
            // decode
            let httpResponse = response as! HTTPURLResponse
            guard (200 ..< 299).contains(httpResponse.statusCode) else {
                print("Invalid response from server")
                return weatherResponse
            }
            weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
        } catch {
            print("Error: Failed to decode Weather url.\n\(error)")
        }
        return weatherResponse
    }
    
    static func loadIcon(name: String) async -> UIImage? {
        var icon: UIImage? = nil
        guard let url = URL(string: "https://openweathermap.org/img/wn/\(name)@2x.png") else {
            return icon
        }
        
        do {
            let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
            let (data, response) = try await URLSession.shared.data(for: request)
            let httpResponse = response as! HTTPURLResponse
            guard (200 ..< 299).contains(httpResponse.statusCode) else {
                print("Error loadIcon: Invalid response from server")
                return icon
            }
            icon = UIImage(data: data)
        } catch {
            print("Failed to load icon for \(name)")
            return icon
        }
        return icon
    }
}
