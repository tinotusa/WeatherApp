//
//  SuggestionsView.swift
//  Weather
//
//  Created by Tino on 4/12/21.
//

import SwiftUI

struct SuggestionsView: View {
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @Environment(\.dismissSearch) var dismissSearch
    
    var body: some View {
        if weatherViewModel.isLoading {
            loadingView
        } else {
            suggestionsList
        }
    }
}

private extension SuggestionsView {
    @ViewBuilder
    var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.thinMaterial)
    }
    
    @ViewBuilder
    var suggestionsList: some View {
        if weatherViewModel.suggestions.isEmpty {
            VStack {
                Text("No results found")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.thinMaterial)
        } else {
            List {
                ForEach(weatherViewModel.suggestions) { suggestion in
                    Button {
                        Task {
                            guard let weather = await NetworkManager.loadDailyWeather(for: suggestion.coord, place: suggestion) else {
                                return
                            }
                            await weatherViewModel.addLocation(weather)
                        }
                        dismissSearch()
                    } label: {
                        Text(suggestion.text)
                    }
                    Text(suggestion.text)
                }
            }
        }
    }
}

struct SuggestionsView_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionsView()
            .environmentObject(WeatherViewModel())
    }
}
