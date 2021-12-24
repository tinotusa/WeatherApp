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
        VStack(alignment: .leading) {
            Text("Additional Info")
                .font(.title)
            HStack {
                label(name: "Wind", value: weather.current.windSpeed, unit: windUnit)
                label(name: "Humidity", value: weather.current.humidity, unit: "%")
            }
            HStack {
                if let rain = weather.current.rain {
                    label(name: "Rain", value: rain, unit: "%")
                }
            }
        }
    }
}

private extension HeaderRow {
    var windUnit: String {
        if Locale.current.usesMetricSystem {
            return "m/s"
        }
        return "m/h"
    }
    
    @ViewBuilder
    func label(name: String, value: Double, unit: String?) -> some View {
        HStack {
            Text(name)
                .bold()
            Text(String(format: "%g", value))
                .foregroundColor(Color("darkGray"))
                .bold()
            Text(unit ?? "")
                .foregroundColor(.secondary)
        }
    }
}

struct HeaderRow_Previews: PreviewProvider {
    static var previews: some View {
        HeaderRow(weather: DailyWeatherResponse.example)
    }
}
