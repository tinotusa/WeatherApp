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
}

extension WeatherDetailViewModel {
    var photoURL: URL? {
        return weather.unsplashedPhoto?.urls.regular
    }
    
    var photoCreditURL: URL? {
        weather.photoCreditURL
    }
    
    var photoCreditName: String? {
        weather.photoCreditName
    }
    
    var photoCreditProfileURL: URL? {
        weather.userPhotoURL
    }
}
