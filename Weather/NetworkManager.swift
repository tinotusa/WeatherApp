//
//  NetworkManager.swift
//  Weather
//
//  Created by Tino on 4/12/21.
//

import Foundation

struct NetworkManager {
    static func loadSuggestions(for place: String) async -> [GeoResponse] {
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
                return []
            }
            let geoData = try JSONDecoder().decode([GeoResponse].self, from: data)
            return geoData
        } catch {
            print("Failed to get data from \(Constants.baseGeoURL).\n\(error)")
        }
        return []
    }
}
