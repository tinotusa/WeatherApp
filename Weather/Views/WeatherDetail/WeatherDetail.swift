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
        ZStack(alignment: .top) {
            background
            ScrollView(showsIndicators: false) {
                GeometryReader { proxy in
                    DetailHeader(weather: weather, proxy: proxy)
//                    Text("proxy: \(proxy.frame(in: .global).minY)")
                }
                .frame(height: 300)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                HourlyRow(weather: weather)
                    .padding(.horizontal)
                
                HeaderRow(weather: weather)
                    .padding(.horizontal)
                
                WeekTemperatureView(weather: weather)
                    .padding(.horizontal)

                Spacer()
            }
            .navigationBarHidden(true)
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
            navButtons
                .padding(.horizontal)
        }
    }
}

private extension WeatherDetail {
    @ViewBuilder
    var navButtons: some View {
        HStack {
            backButton
            Spacer()
            deleteButton
        }
    }
    
    @ViewBuilder
    var background: some View {
        if weather.unsplashedPhoto?.color != nil {
            LinearGradient(
                colors: [
                    Color(hex: weather.unsplashedPhoto!.color),
                    Color(hex: weather.unsplashedPhoto!.color).opacity(0.3)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        }
    }
    
    var backButton: some View {
        Button("Back") {
            dismiss()
        }
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
