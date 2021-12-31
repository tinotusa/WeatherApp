//
//  DailyWeatherResponse+NSItemProviderWriting.swift
//  Weather
//
//  Created by Tino on 28/12/21.
//

import SwiftUI

extension DailyWeatherResponse: NSItemProviderWriting {
    static let typeIdentifier = "com.tusatino.Weather.dailyWeatherResponse"
    
    static var writableTypeIdentifiersForItemProvider: [String] {
        [typeIdentifier]
    }

    func loadData(
        withTypeIdentifier typeIdentifier: String,
        forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void
    ) -> Progress?
    {
        let encoder = JSONEncoder()
        do {
            completionHandler(try encoder.encode(self), nil)
        } catch {
            completionHandler(nil, error)
        }
        return nil
    }
}


extension DailyWeatherResponse: NSItemProviderReading {
    static var readableTypeIdentifiersForItemProvider: [String] {
        [typeIdentifier]
    }
    
    static func object(withItemProviderData data: Data,
        typeIdentifier: String) throws -> Self
    {
        let decoder = JSONDecoder()
        return try decoder.decode(DailyWeatherResponse.self, from: data) as! Self
    }
}
