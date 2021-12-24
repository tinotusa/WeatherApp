//
//  DetailHeader.swift
//  Weather
//
//  Created by Tino on 12/12/21.
//

import SwiftUI

struct DetailHeader: View {
    private struct Constants {
        static let iconHeight = 100.0
        static let iconWidth = iconHeight
    }
    
    let weather: DailyWeatherResponse
    @EnvironmentObject var viewModel: WeatherViewModel
    
    var body: some View {
        VStack {
            Image(systemName: iconName(for: weather.iconID))
                .resizable()
                .renderingMode(.original)
                .frame(width: Constants.iconWidth, height: Constants.iconHeight)
            Text("\(weather.temp)")
                .font(.largeTitle)
                .bold()
            Text("\(weather.description.capitalizeFirst)")
            Spacer()
        }
    }
}

struct DetailHeader_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DetailHeader(weather: DailyWeatherResponse.example)
                
            DetailHeader(weather: DailyWeatherResponse.example)
                .preferredColorScheme(.dark)
        }
        .environmentObject(WeatherViewModel())
    }
}
