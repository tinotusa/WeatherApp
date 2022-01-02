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
                if locationManager.lastLocation != nil {
                    let coords = Coordinates(
                        lon: locationManager.lastLocation!.coordinate.longitude,
                        lat: locationManager.lastLocation!.coordinate.latitude
                    )
                    guard let place = await NetworkManager.loadPlace(lon: coords.lon, lat: coords.lat) else { return }
                    guard let weather = await NetworkManager.loadDailyWeather(for: coords, place: place.convertToGeoResponse()) else { return }
                    if !viewModel.weather.contains(where: {$0.place?.cityID == place.id }) {
                        viewModel.weather.insert(weather, at: 0)
                        viewModel.save()
                    }
                }
            }
        }
        .task {
            URLCache.shared.memoryCapacity = 1024 * 1024 * 256
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
                    .font(.title)
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
                                    currentWeather: weather, draggedWeather: draggedWeather
                                )
                            )
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
