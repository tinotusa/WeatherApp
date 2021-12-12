//
//  WeatherRow.swift
//  Weather
//
//  Created by Tino on 4/12/21.
//

import SwiftUI

struct WeatherRow: View {
    struct Constants {
        static let width = 50.0
        static let height = 50.0
    }
    
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    var weather: DailyWeatherResponse
    
    var body: some View {
        NavigationLink(destination: WeatherDetail(weather: weather)) {
            ZStack(alignment: .bottomLeading) {
                AsyncImage(url: weather.unsplashedPhoto?.urls.regular) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 150)
                        .clipped()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 146)

                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Text(weather.name)
                        .font(.largeTitle)
                        .foregroundColor(Color("text"))

                        Spacer()

                        VStack(alignment: .trailing) {
                            HStack {
                                Image(systemName: iconName(for: weather.daily.first!.weather.first!.id))
                                    .resizable()
                                    .frame(width: Constants.width, height: Constants.height)
                                Text("\(weather.daily.first!.temp.day)")
                                    .font(.largeTitle)
                            }

                            Spacer()

                            Text("Min: \(weather.daily.first!.temp.min)")
                            Text("Max: \(weather.daily.first!.temp.max)")
                        }
                    }
                }
            }
            .foregroundColor(Color("text"))
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
