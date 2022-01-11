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
                ForEach(Array(weather.daily.enumerated()), id: \.offset) { index, day in
                    ZStack {
                        if index == 0 {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(Color("highlight").opacity(0.2))
                        }
                        VStack {
                            Text("\(Weekday.weekday(from: day.date.addingTimeInterval(weather.timezone_offset)).shortName)")
                            Image(systemName: iconName(for: day.iconID))
                                .symbolRenderingMode(.multicolor)
                                .font(.largeTitle)
                            Text(day.dayTemp)
                        }
                        .smallFont()
                        .foregroundColor(Color("text"))
                        .padding()
                    }
                }
            }
        }
        .padding()
        .ultraThinMaterialShadow()
        .cornerRadius(15)
    }
}


struct WeekTemperatureView_Previews: PreviewProvider {
    static var previews: some View {
        WeekTemperatureView(weather: DailyWeatherResponse.example)
            .previewLayout(.fixed(width: 500, height: 140))
    }
}
