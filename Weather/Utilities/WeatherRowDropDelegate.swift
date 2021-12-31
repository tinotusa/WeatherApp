//
//  WeatherRowDropDelegate.swift
//  Weather
//
//  Created by Tino on 28/12/21.
//

import Foundation
import SwiftUI

struct WeatherRowDropDelegate: DropDelegate {
    let typeID = DailyWeatherResponse.typeIdentifier
    
    @Binding var weatherList: [DailyWeatherResponse]
    var currentWeather: DailyWeatherResponse
    var draggedWeather: DailyWeatherResponse!
    
    func dropEntered(info: DropInfo) {
        guard let fromIndex = weatherList.firstIndex(of: currentWeather) else { return }
        guard let toIndex = weatherList.firstIndex(of: draggedWeather) else { return }
        if fromIndex == toIndex { return }
        withAnimation {
            weatherList.swapAt(fromIndex, toIndex)
        }
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        return true
    }
}
