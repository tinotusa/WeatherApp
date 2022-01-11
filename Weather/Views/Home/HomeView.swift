//
//  ContentView.swift
//  Weather
//
//  Created by Tino on 29/11/21.
//

import SwiftUI
import CoreLocation

struct HomeView: View {
    @EnvironmentObject var viewModel: WeatherViewModel
    @State private var searchText = ""
    @StateObject var locationManager = LocationManager()
    @State private var draggedWeather: DailyWeatherResponse?
    
    var body: some View {
        NavigationView {
            homeView
                .overlay {
                    if !searchText.isEmpty {
                        SuggestionsView()
                    }
                }
                .navigationTitle("Weather")
        }
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Enter a location"
        )
        .onSubmit(of: .search) {
            Task {
                await viewModel.searchAPI(for: searchText)
            }
        }
        .onReceive(locationManager.$lastLocation) { location in
            Task {
                await viewModel.addUserLocation(locationManager)
            }
        }
        .task {
            await viewModel.loadWeather()
        }
    }
}

private extension HomeView {
    @ViewBuilder
    var homeView: some View {
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
    }
}

struct HomeView_Previews: PreviewProvider {
    static let viewModel: WeatherViewModel = {
        let model = WeatherViewModel()
        model.weather = [DailyWeatherResponse.example]
        return model
    }()
    
    static var previews: some View {
        HomeView()
            .previewDisplayName("With empty locations")
            .environmentObject(WeatherViewModel())
    }
}
