//
//  GeoResponseTest.swift
//  WeatherTests
//
//  Created by Tino on 24/12/21.
//

import XCTest
@testable import Weather

struct TestValues {
    static let name = "test name"
    static let country = "Ontario"
    static let state = "soemthing"
    static let lat = 123.4
    static let lon = 123.4
}

class GeoResponseTest: XCTestCase {
    let geoResponseJSON = """
    {
        "name": "\(TestValues.name)",
        "lat": \(TestValues.lat),
        "lon": \(TestValues.lon),
        "country": "\(TestValues.country)",
        "state": "\(TestValues.state)",
    }
    """
    let badGeoResponseJSON = """
    {
        "namx": "test name",
        "lon": 123.4,
        "country": "Ontario",
        "state": "Something",
    }
    """
    
    func test_decodeSuccess() throws {
        let data = geoResponseJSON.data(using: .utf8)
        XCTAssertNotNil(data)
        do {
            let response = try JSONDecoder().decode(GeoResponse.self, from: data!)
            XCTAssertTrue(response.name == TestValues.name)
            XCTAssertTrue(response.lat == TestValues.lat)
            XCTAssertTrue(response.lon == TestValues.lon)
            XCTAssertTrue(response.country == TestValues.country)
            XCTAssertTrue(response.state == TestValues.state)
        } catch {
            throw error
        }
    }
    
    func test_decodeFailure() {
        let data = badGeoResponseJSON.data(using: .utf8)
        XCTAssertNotNil(data)
        XCTAssertThrowsError(try JSONDecoder().decode(GeoResponse.self, from: data!))
    }
}
