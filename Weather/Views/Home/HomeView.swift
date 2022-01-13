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
    
    var body: some View {
        NavigationView {
            WeatherRowsView()
        }
        .navigationViewStyle(.stack)
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
