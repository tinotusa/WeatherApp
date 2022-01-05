//
//  WeatherDetail.swift
//  Weather
//
//  Created by Tino on 10/12/21.
//

import SwiftUI

struct WeatherDetail: View {
    @StateObject var detailViewModel: WeatherDetailViewModel
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
                    HourlyRow(weather: detailViewModel.weather)
                    
                    WeekTemperatureView(weather: detailViewModel.weather)
                    
                    Spacer()
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
                        dismiss()
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
    }
}

private extension WeatherDetail {
    @ViewBuilder
    var backgroundImage: some View {
        AsyncImage(url: detailViewModel.photoURL) { image in
            image
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .blur(radius: 10)
        } placeholder: {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                Spacer()
            }
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
