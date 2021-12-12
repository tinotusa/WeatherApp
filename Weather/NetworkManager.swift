//
//  NetworkManager.swift
//  Weather
//
//  Created by Tino on 4/12/21.
//

import Foundation
import SwiftUI

struct NetworkManager {
    // MARK: - Openweathermap
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
    
    private static func buildURL(string: String, parameters: [String: String]) -> URL? {
        guard var urlComponents = URLComponents(string: string) else {
            fatalError("Error \(#function) failed to create url from string: \(string)")
        }
        
        urlComponents.queryItems = parameters.map { parameter, value in
            URLQueryItem(name: parameter, value: value)
        }
        return urlComponents.url
    }
    
    static func loadDailyWeather(for location: Coordinates, name: String) async -> DailyWeatherResponse? {
        let queries = [
            "lat": "\(location.lat)",
            "lon": "\(location.lon)",
            "appid": Constants.weatherAPIKey,
            "cnt": "7",
            "units": Locale.current.usesMetricSystem ? "metric" : "imperial",
            "lang": Locale.current.languageCode ?? "en",
            "exclude": "current,minutely,hourly",
        ]
        
        guard let url = buildURL(string: Constants.baseDailyWeatherURL, parameters: queries) else {
            fatalError("Error \(#function) failed to load daily weather from \(Constants.baseDailyWeatherURL)")
        }
        
        do {
            let request = URLRequest(url: url)
            let (data, response) = try await URLSession.shared.data(for: request)
            let httpResponse = response as! HTTPURLResponse
            guard (200 ..< 299).contains(httpResponse.statusCode) else {
                print("Server reponse error code: \(httpResponse.statusCode)")
                return nil
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            var dailyWeather = try decoder.decode(DailyWeatherResponse.self, from: data)
            dailyWeather.name = name
            return dailyWeather
        } catch {
            print("Error in \(#function). Failed to decode data from url.\n\(error)")
        }
        return nil
    }
    
    // MARK: - Pexels
    static func loadImage(name: String) async -> UnsplashedSearchResponse? {
        let parameters = [
            "query": name,
            "orientation": "landscape",
            "client_id": Constants.unsplashedAPIKey
        ]
        
        guard let url = buildURL(string: Constants.unsplashedURL, parameters: parameters) else {
            fatalError("Failed to construct url from \(Constants.unsplashedURL) with parameters: \(parameters)")
        }
        
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        
        var photos: UnsplashedSearchResponse? = nil
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            let httpResponse = response as! HTTPURLResponse
            guard (200 ... 299).contains(httpResponse.statusCode) else {
                fatalError("Error \(#function). Invalid server response code \(httpResponse.statusCode)")
            }
            photos = try JSONDecoder().decode(UnsplashedSearchResponse.self, from: data)
        } catch {
            print("Error \(#function) failed to decode search response.\n\(error)")
        }
        return photos
    }
}

struct UnsplashedPhotoURLS: Codable {
    let raw: URL
    let full: URL
    let regular: URL
    let small: URL
    let thumb: URL
}

struct UnsplashedPhoto: Codable, Identifiable {
    let id: String
    let width: Int
    let height: Int
    let color: String
    // TODO: get user links for credit
    let urls: UnsplashedPhotoURLS
}

struct UnsplashedSearchResponse: Codable {
    let total: Int
    let results: [UnsplashedPhoto]
}
