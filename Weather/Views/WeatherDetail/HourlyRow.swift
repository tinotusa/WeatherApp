//
//  HourlyRow.swift
//  Weather
//
//  Created by Tino on 24/12/21.
//

import SwiftUI

struct HourlyRow: View {
    let weather: DailyWeatherResponse
    
    struct Constants {
        static let width = 30.0
        static let height = 30.0
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Hourly")
                .bold()
                .font(.title)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(weather.nextTwelveHours) { hour in
                        VStack {
                            Text("\(hour.formattedTime)")
                            Image(systemName: iconName(for: hour.iconID))
                                .resizable()
                                .renderingMode(.original)
                                .frame(width: Constants.width, height: Constants.height)
                            Text(formatTemp(hour.temp))
                        }
                        .padding(.trailing)
                    }
                }
            }
        }
    }
}

struct HourlyRow_Previews: PreviewProvider {
    static var previews: some View {
        HourlyRow(weather: DailyWeatherResponse.example)
            .environmentObject(WeatherViewModel())
    }
}
