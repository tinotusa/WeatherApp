//
//  DetailHeader.swift
//  Weather
//
//  Created by Tino on 12/12/21.
//

import SwiftUI

struct DetailHeader: View {
    private struct Constants {
        static let iconHeight = 60.0
        static let iconWidth = iconHeight
    }
    
    let weather: DailyWeatherResponse
    let proxy: GeometryProxy!
    @EnvironmentObject var viewModel: WeatherViewModel
    
    func clamp(_ value: Double, from min: Double, to max: Double) -> Double {
        if value <= min {
            return min
        } else if value >= max {
            return max
        }
        return value
    }
    
    func scale(in proxy: GeometryProxy) -> Double {
        return proxy.frame(in: .global).minY * 0.1

    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: weather.unsplashedPhoto?.urls.regular) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .ignoresSafeArea()
//                    .scaleEffect(scale(in: proxy), anchor: .bottom)
            } placeholder: {
                ProgressView()
            }

            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Text(weather.name)
                        .font(.largeTitle)
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
                Spacer()
            }
        }
    }
}

struct DetailHeader_Previews: PreviewProvider {
    static var previews: some View {
        DetailHeader(weather: DailyWeatherResponse.example, proxy: nil)
            .environmentObject(WeatherViewModel())
    }
}
