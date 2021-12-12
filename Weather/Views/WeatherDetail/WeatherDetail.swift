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
    
    @State private var backgroundColor: Color? = nil
    @State private var showingDeleteDialog = false
    @State private var imageURL: URL? = nil
    
    var body: some View {
        ZStack(alignment: .top) {
            background
            
            ScrollView(showsIndicators: false) {
                DetailHeader(imageURL: imageURL, weather: weather)
                
                HeaderRow(weather: weather)
                    .padding(.horizontal)

                Divider()
                
                WeekTemperatureView(weather: weather)
                    .padding(.horizontal)

                Spacer()
            }
            
            .navigationBarHidden(true)
            .task {
                await loadPhotos()
            }
            .toolbar {
                deleteButton
            }
            .confirmationDialog(
                Text("Permanently erase the items in the trash?"),
                isPresented: $showingDeleteDialog
            ) {
                Button("Delete", role: .destructive) {
    //                viewModel.removeWeather(weather)
                    dismiss()
                }
            }
            
            navButtons
                .padding(.horizontal)
        }
    }
}

private extension WeatherDetail {
    func loadPhotos() async {
        guard let photos = await NetworkManager.loadImage(name: viewModel.getName(for: weather.coord)) else {
            return
        }
        imageURL = photos.results.first!.urls.regular
        backgroundColor = Color(hex: photos.results.first!.color)
    }
    
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
        if backgroundColor != nil {
            backgroundColor!
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
