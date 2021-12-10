//
//  ContentView.swift
//  Weather
//
//  Created by Tino on 29/11/21.
//

import SwiftUI


struct HomeView: View {
    @EnvironmentObject var viewModel: WeatherViewModel
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                homeView
                    .overlay {
                        if !searchText.isEmpty {
                            SuggestionsView()
                        }
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
        .task {
            await viewModel.loadDailyWeather()
            URLCache.shared.memoryCapacity = 1024 * 1024 * 256
        }
    }
}

private extension HomeView {
    @ViewBuilder
    var homeView: some View {
        ScrollView(showsIndicators: false) {
            Group {
                if viewModel.hasLocations {
                    ForEach(viewModel.dailyWeather) { weather in
                        WeatherRow(weather: weather)
                    }
                } else {
                    Text("Add a location by tapping the search bar")
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static let viewModel: WeatherViewModel = {
        let model = WeatherViewModel()
//        model.dailyWeather = [DailyWeatherResponse.example]
        return model
    }()
    
    static var previews: some View {
        Group {
            HomeView()
                .previewDisplayName("With locations")
                .environmentObject(viewModel)
            HomeView()
                .previewDisplayName("With empty locations")
                .environmentObject(WeatherViewModel())
        }
        
    }
}
