//
//  DetailHeader.swift
//  Weather
//
//  Created by Tino on 12/12/21.
//

import SwiftUI

struct DetailHeader: View {
    let imageURL: URL?
    let weather: DailyWeatherResponse
    @EnvironmentObject var viewModel: WeatherViewModel
    
    var body: some View {
        ZStack {
            AsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            } placeholder: {
                ProgressView()
            }
            VStack {
                Text(weather.name)
                    .font(.title2)
                Text("\(weather.daily.first!.temp.day)")
                    .font(.largeTitle)
                    .bold()
                Text("\(weather.daily.first!.description.first!.description)")
            }
        }
    }
}

struct DetailHeader_Previews: PreviewProvider {
    static var previews: some View {
        DetailHeader(imageURL: nil, weather: DailyWeatherResponse.example)
            .environmentObject(WeatherViewModel())
    }
}
