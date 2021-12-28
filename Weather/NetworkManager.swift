//
//  NetworkManager.swift
//  Weather
//
//  Created by Tino on 4/12/21.
//

import Foundation

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
    
    static func loadPlace(lon: Double, lat: Double) async -> GeoCoordResponse? {
        let parameters = [
            "lon": "\(lon)",
            "lat": "\(lat)",
            "appid": Constants.weatherAPIKey,
            "units": Locale.current.usesMetricSystem ? "metric" : "imperial",
            "lang": Locale.current.languageCode ?? "en"
        ]
        let urlString = Constants.baseGeoCoordURL
        guard let url = buildURL(string: urlString, parameters: parameters) else {
            fatalError("Failed to build url from string \(urlString)\nWith parameters: \(parameters)")
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            if let httpResponse = response as? HTTPURLResponse,
               !(200 ..< 299).contains(httpResponse.statusCode)
            {
                print("Error: invalid response from server in \(#function)")
                return nil
            }
            return try JSONDecoder().decode(GeoCoordResponse.self, from: data)
        } catch {
            print("Error in \(#function)failed to decode data")
            print(url)
        }
        return nil
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
    
    static func loadDailyWeather(for location: Coordinates, place: GeoResponse) async -> DailyWeatherResponse? {
        let queries = [
            "lat": "\(location.lat)",
            "lon": "\(location.lon)",
            "appid": Constants.weatherAPIKey,
            "cnt": "7",
            "units": Locale.current.usesMetricSystem ? "metric" : "imperial",
            "lang": Locale.current.languageCode ?? "en",
            "exclude": "current,minutely",
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
            dailyWeather.place = place
            let photo = await loadImage(name: place.text)
            if let photo = photo, !photo.results.isEmpty {
                dailyWeather.unsplashedPhoto = photo.results.randomElement()!
            }
            return dailyWeather
        } catch {
            print("Error in \(#function). Failed to decode data from url (\(url)).\n\(error)")
        }
        return nil
    }
    
    // MARK: - Unsplashed
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
