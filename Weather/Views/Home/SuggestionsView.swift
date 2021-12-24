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
        VStack {
            if weatherViewModel.isLoading {
                Spacer()
                ProgressView()
                Spacer()
            } else {
                suggestionsList
            }
        }
    }
}

private extension SuggestionsView {
    @ViewBuilder
    var suggestionsList: some View {
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

struct SuggestionsView_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionsView()
            .environmentObject(WeatherViewModel())
    }
}
