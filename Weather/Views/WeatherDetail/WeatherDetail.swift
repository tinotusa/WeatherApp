//
//  WeatherDetail.swift
//  Weather
//
//  Created by Tino on 10/12/21.
//

import SwiftUI

struct WeatherDetail: View {
    let weather: DailyWeatherResponse
    
    @EnvironmentObject var viewModel: WeatherViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var showingDeleteDialog = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color("background")
                .ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                        DetailHeader(weather: weather)
                        Spacer()
                    }
                    
                    weatherWarning
                    
                    HourlyRow(weather: weather)
                        .padding(.bottom)

                    WeekTemperatureView(weather: weather)
                        .padding(.bottom)
                    
                    HeaderRow(weather: weather)
                }
                .padding(.horizontal)
            }
            footer
        }
        .navigationTitle(weather.place?.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            deleteButton
        }
        .confirmationDialog(
            Text("Permanently erase the items in the trash?"),
            isPresented: $showingDeleteDialog
        ) {
            Button("Delete", role: .destructive) {
                viewModel.removeWeather(weather)
                dismiss()
            }
        }
    }
}

private extension WeatherDetail {
    @ViewBuilder
    var weatherWarning: some View {
        if weather.hasAlert {
            Text("Warning")
                .bold()
                .font(.title)
            Text(weather.alerts!.first!.event)
        }
    }
    
    @ViewBuilder
    var footer: some View {
        HStack {
            Spacer()
            Link(destination: URL(string: "https://openweathermap.org")!) {
                Text("OpenWeatherMaps.org")
            }
            Spacer()
        }
        .background(Color("background"))
    }

    var deleteButton: some View {
        Button {
            showingDeleteDialog = true
        } label: {
            Image(systemName: "trash")
        }
    }
}

struct WeatherDetail_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetail(weather: DailyWeatherResponse.example)
            .environmentObject(WeatherViewModel())
    }
}
