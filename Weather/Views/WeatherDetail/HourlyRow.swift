//
//  HourlyRow.swift
//  Weather
//
//  Created by Tino on 24/12/21.
//

import SwiftUI

struct HourlyRow: View {
    let weather: DailyWeatherResponse

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(Array(weather.nextTwelveHours.enumerated()), id: \.offset) { index, hour in
                    ZStack(alignment: .bottom) {
                        if index == 0 {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(Color("highlight").opacity(0.2))
                        }
                        VStack(spacing: 0) {
                            Text("\(hour.formattedTime)")
                            Image(systemName: iconName(for: hour.iconID))
                                .renderingMode(.original)
                                .font(.largeTitle)
                            Text(formatTemp(hour.temp))
                        }
                        .font(.title2)
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
struct HourlyRow_Previews: PreviewProvider {
    static var previews: some View {
        HourlyRow(weather: DailyWeatherResponse.example)
            .environmentObject(WeatherViewModel())
            .background(.black.opacity(0.8))
            .previewLayout(.fixed(width: 450, height: 140))
    }
}
