//
//  DetailHeader.swift
//  Weather
//
//  Created by Tino on 12/12/21.
//

import SwiftUI

struct DetailHeader: View {
    private struct Constants {
        static let iconHeight = 50.0
        static let iconWidth = iconHeight
    }
    
    let weather: DailyWeatherResponse
    @EnvironmentObject var viewModel: WeatherViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(weather.place?.fullname ?? "N/A")
                .multilineTextAlignment(.center)
            
            HStack {
                Spacer()
                VStack {
                    Image(systemName: iconName(for: weather.iconID))
                        .renderingMode(.original)
                        .largeFont()
                    Text("\(weather.temp)")
                        .largeFont()
                    Text("\(weather.weatherDescription.capitalizeFirst)")
                }
                Spacer()
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Label("\(weather.maxTemp)", systemImage: "thermometer.sun.fill")
                    Label("\(weather.minTemp)", systemImage: "thermometer.snowflake")
                }
                .symbolRenderingMode(.multicolor)
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Label("\(weather.sunrise)", systemImage: "sunrise.fill")
                    Label("\(weather.sunset)", systemImage: "sunset.fill")
                }
                .symbolRenderingMode(.multicolor)
            }
        }
        .padding()
        .foregroundColor(Color("text"))
        .ultraThinMaterialShadow()
        .cornerRadius(15)
    }
}

struct DetailHeader_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DetailHeader(weather: DailyWeatherResponse.example)
                
            DetailHeader(weather: DailyWeatherResponse.example)
                .preferredColorScheme(.dark)
        }
        .background(.black.opacity(0.8))
        .environmentObject(WeatherViewModel())
    }
}
