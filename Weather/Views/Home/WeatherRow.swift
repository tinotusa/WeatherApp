//
//  WeatherRow.swift
//  Weather
//
//  Created by Tino on 4/12/21.
//

import SwiftUI

struct WeatherRow: View {
    private struct Constants {
        static let width = 25.0
        static let height = 25.0
        static let imageHeight = 150.0
    }
    
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    var weather: DailyWeatherResponse
    
    var body: some View {
        NavigationLink(destination: WeatherDetail(weather: weather)) {
            ZStack(alignment: .bottomLeading) {
                headerImage

                VStack(alignment: .leading) {
                    if weather.hasAlert {
                        HStack(alignment: .firstTextBaseline) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: Constants.width / 2, height: Constants.height / 2)
                            Text(weather.alertEvent!)
                                .smallFont()
                        }
                        .padding(.top)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Text(weather.name.isEmpty ? "Your location" : weather.name)
                            .lineLimit(1)
                            .rowTitleFont()
                        Spacer()
                        temperatures
                    }
                }
                .padding(.horizontal)
            }
            .cornerRadius(15)
            .foregroundColor(Color("text"))
            .padding(.horizontal)
        }
        .accessibilityIdentifier("weatherRowButton")
    }
}

private extension WeatherRow {
    var temperatures: some View {
        HStack {
            Image(systemName: iconName(for: weather.iconID))
                .renderingMode(.original)
            Text("\(weather.temp)")
        }
        .largeFont()
        .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 4)
    }
    
    @ViewBuilder
    var headerImage: some View {
        ImageLoaderView(url: weather.unsplashedPhoto?.urls.regular) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(height: Constants.imageHeight)
                .clipped()
        } placeholder: {
            ProgressView()
                .centered()
        }
        .frame(height: Constants.imageHeight)
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
