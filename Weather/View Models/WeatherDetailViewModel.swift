//
//  WeatherDetailViewModel.swift
//  Weather
//
//  Created by Tino on 2/1/22.
//

import Foundation

final class WeatherDetailViewModel: ObservableObject {
    let weather: DailyWeatherResponse
    
    @Published var showingDeleteDialog = false
    @Published var showMore = false
    
    init(weather: DailyWeatherResponse) {
        self.weather = weather
    }
    
    static func dateFormatter(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

extension WeatherDetailViewModel {
    var photoURL: URL? {
        return weather.unsplashedPhoto?.urls.regular
    }
}
