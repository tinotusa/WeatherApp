//
//  WeatherRow.swift
//  Weather
//
//  Created by Tino on 4/12/21.
//

import SwiftUI

struct WeatherRow: View {
    private struct Constants {
        static let width = 50.0
        static let height = 50.0
        static let imageHeight = 150.0
    }
    
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    var weather: DailyWeatherResponse
    
    var body: some View {
        NavigationLink(destination: WeatherDetail(weather: weather)) {
            ZStack(alignment: .bottomLeading) {
                headerImage

                HStack(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        if weather.hasAlert {
                            HStack(alignment: .firstTextBaseline) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width: Constants.width / 2, height: Constants.height / 2)
                                Text(weather.alerts!.first!.event)
                                    .font(.title3)
                            }
                        }
                        Spacer()
                        Text(weather.name.isEmpty ? "Your location" : weather.name)
                            .font(.largeTitle)
                            .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 4)
                    }
                    .padding(.top)
                    
                    Spacer()
                    
                    temperatures
                }
                .padding(.horizontal)
            }
            .cornerRadius(20)
            .foregroundColor(Color("text"))
            .padding(.horizontal)
        }
    }
}

private extension WeatherRow {
    var temperatures: some View {
        VStack(spacing: 0) {
            Image(systemName: iconName(for: weather.iconID))
                .renderingMode(.original)
                .resizable()
                .frame(width: Constants.width, height: Constants.height)
            Text("\(weather.temp)")
                .font(.largeTitle)
        }
        .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 4)
    }
    
    @ViewBuilder
    var headerImage: some View {
        if weather.unsplashedPhoto == nil {
            Color.gray
                .frame(height: Constants.imageHeight)
        } else {
            AsyncImage(url: weather.unsplashedPhoto?.urls.regular) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(height: Constants.imageHeight)
                    .clipped()
            } placeholder: {
                ProgressView()
            }
            .frame(height: Constants.imageHeight)
        }
    }
}

struct WeatherRow_Previews: PreviewProvider {
    static var previews: some View {
        WeatherRow(weather: DailyWeatherResponse.example)
            .environmentObject(WeatherViewModel())
            .previewLayout(.fixed(width: 560.0, height: 150.0))
            .background(.gray)
    }
}
