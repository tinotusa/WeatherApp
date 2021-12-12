//
//  HeaderRow.swift
//  Weather
//
//  Created by Tino on 12/12/21.
//

import SwiftUI

struct HeaderRow: View {
    let weather: DailyWeatherResponse
    let iconWidth = 60.0
    let iconHeight = 60.0
    
    var body: some View {
        HStack {
            icon(label: "Wind", systemName: "wind", text: "\(weather.daily.first!.windDeg)m/s")
            Spacer()
            icon(label: "Rain", systemName: "cloud.rain", text: "\(weather.daily.first!.rain ?? 0)%")
            Spacer()
            icon(label: "Humidity", systemName: "humidity", text: "\(weather.daily.first!.humidity)%")
        }
        .roundedThinMaterial()
    }
}

private extension HeaderRow {
    @ViewBuilder
    func icon(label: String, systemName: String, text: String) -> some View {
        VStack {
            Image(systemName: systemName)
                .resizable()
                .frame(width: iconWidth, height: iconHeight)
            Text(text)
            Text(label)
        }
    }
}

struct HeaderRow_Previews: PreviewProvider {
    static var previews: some View {
        HeaderRow(weather: DailyWeatherResponse.example)
    }
}
