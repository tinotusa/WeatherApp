//
//  GeoResponse.swift
//  Weather
//
//  Created by Tino on 4/12/21.
//

import Foundation

struct GeoResponse: Codable, Identifiable, Equatable {
    let name: String
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
    let id = UUID()
    
    enum CodingKeys: CodingKey {
        case name, lat, lon, country, state
    }

    var text: String {
        if state != nil {
            return "\(name), \(state!), \(country)"
        }
        return "\(name), \(country)"
    }
    
    static func ==(_ lhs: GeoResponse, _ rhs: GeoResponse) -> Bool {
        lhs.text == rhs.text
    }
    
    static var example: GeoResponse {
        return .init(
            name: "test name\(Int.random(in: 0  ..< 100))",
            lat: 0.0,
            lon: 0.0,
            country: "AU",
            state: nil
        )
    }
}
