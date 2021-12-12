//
//  WeekTemperatureView.swift
//  Weather
//
//  Created by Tino on 12/12/21.
//

import SwiftUI

struct WeekTemperatureView: View {
    let weather: DailyWeatherResponse
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(weather.daily) { day in
                    VStack {
                        Text("\(Weekday.weekday(from: day.date).shortName)")
                        Image(systemName: iconName(for: day.weather.first!.id))
                        Text("\(day.temp.day)ºC")
                    }
                    Spacer()
                }
            }
        }
        .roundedThinMaterial()
    }
}


struct WeekTemperatureView_Previews: PreviewProvider {
    static var previews: some View {
        WeekTemperatureView(weather: DailyWeatherResponse.example)
    }
}
