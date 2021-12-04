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
    }
}

private extension HomeView {
    @ViewBuilder
    var homeView: some View {
        ScrollView(showsIndicators: false) {
            Group {
                if viewModel.hasLocations {
                    ForEach(viewModel.locations) { location in
                        WeatherRow(location: location)
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
        model.locations = [GeoResponse.example, GeoResponse.example, GeoResponse.example]
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
