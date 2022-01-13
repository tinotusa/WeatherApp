//
//  WeatherRowsView.swift
//  Weather
//
//  Created by Tino on 13/1/22.
//

import SwiftUI

struct WeatherRowsView: View {
    @EnvironmentObject var viewModel: WeatherViewModel
    @State private var draggedWeather: DailyWeatherResponse?
    @Environment(\.isSearching) var isSearching
    
    var body: some View {
        VStack {
            if !viewModel.hasWeatherItems {
                Spacer()
                Text("Search for a location.")
                    .bodyFont()
                    .foregroundColor(.secondary)
                Spacer()
            } else {
                ScrollView(showsIndicators: false) {
                    ForEach(viewModel.weather) { weather in
                        WeatherRow(weather: weather)
                            .disabled(viewModel.isLoading)
                            .onDrag {
                                draggedWeather = weather
                                return NSItemProvider(object: weather)
                            }
                            .onDrop(
                                of: [DailyWeatherResponse.typeIdentifier],
                                delegate: WeatherRowDropDelegate(
                                    weatherList: $viewModel.weather,
                                    currentWeather: weather,
                                    draggedWeather: draggedWeather
                                )
                            )
                    }
                    Spacer()
                    Link(destination: URL(string: "https://openweathermap.org")!) {
                        Text("Weather data from OpenWeatherMap.org")
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .overlay {
            if isSearching {
                SuggestionsView()
            }
        }
        .navigationTitle("Weather")
    }
}

struct WeatherRowsView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherRowsView()
            .environmentObject(WeatherViewModel())
    }
}
