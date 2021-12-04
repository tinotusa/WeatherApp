//
//  SuggestionsView.swift
//  Weather
//
//  Created by Tino on 4/12/21.
//

import SwiftUI
import Combine

struct SuggestionsView: View {
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @Environment(\.dismissSearch) var dismissSearch
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                if weatherViewModel.isLoading {
                    ProgressView()
                } else {
                    ForEach(weatherViewModel.suggestions) { suggestion in
                        Button {
                            weatherViewModel.addLocation(suggestion)
                            dismissSearch()
                        } label: {
                            Text(suggestion.text)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .background(.thinMaterial)
    }
}

struct SuggestionsView_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionsView()
            .environmentObject(WeatherViewModel())
    }
}
