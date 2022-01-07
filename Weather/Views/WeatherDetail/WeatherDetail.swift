//
//  WeatherDetail.swift
//  Weather
//
//  Created by Tino on 10/12/21.
//

import SwiftUI

struct WeatherDetail: View {
    @StateObject var detailViewModel: WeatherDetailViewModel
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @Environment(\.dismiss) var dismiss
    
    init(weather: DailyWeatherResponse) {
        _detailViewModel = StateObject(wrappedValue: WeatherDetailViewModel(weather: weather))
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                backgroundImage
                    .frame(width: proxy.size.width, height: proxy.size.height)
                
                ScrollView(showsIndicators: false) {
                    DetailHeader(weather: detailViewModel.weather)
                        .padding(.top, proxy.size.height * 0.05)
                    
                    if detailViewModel.weather.hasAlert {
                        WeatherWarning(weather: detailViewModel.weather)
                    }
                    
                    HourlyRow(weather: detailViewModel.weather)
                    
                    WeekTemperatureView(weather: detailViewModel.weather)
                    
                    MoreInfoGrid(weather: detailViewModel.weather)
                    
                    Spacer()
                    photoCredit
                }
                .padding(.horizontal)
                
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Label("Weather", systemImage: "chevron.left")
                            .symbolRenderingMode(.monochrome)
                    }

                    Spacer()
                    Button {
                        detailViewModel.showingDeleteDialog = true
                    } label: {
                        Image(systemName: "trash")
                            .renderingMode(.original)
                    }
                }
                .padding(.horizontal)
                .font(.title2)
            }
        }
        .navigationBarHidden(true)
        .confirmationDialog(
            "Delete location",
            isPresented: $detailViewModel.showingDeleteDialog,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                weatherViewModel.removeWeather(detailViewModel.weather)
                dismiss()
            }
        }
    }
}

private extension WeatherDetail {
    @ViewBuilder
    var photoCredit: some View {
        if detailViewModel.photoCreditURL != nil {
            Link(destination: detailViewModel.photoCreditURL!) {
                HStack {
                    Text("Photo by: \(detailViewModel.photoCreditName!)")
                        .foregroundColor(Color("text"))
                    AsyncImage(url: detailViewModel.photoCreditProfileURL) { image in
                        image
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    } placeholder: {
                        ProgressView()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    var backgroundImage: some View {
        AsyncImage(url: detailViewModel.photoURL) { image in
            image
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .blur(radius: 10)
        } placeholder: {
            ProgressView()
                .centered()
        }
    }
}

struct WeatherDetail_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetail(weather: DailyWeatherResponse.example)
            .environmentObject(WeatherViewModel())
            .background(.black.opacity(0.8))
    }
}
