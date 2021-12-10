//
//  WeatherDetail.swift
//  Weather
//
//  Created by Tino on 10/12/21.
//

import SwiftUI

enum Weekdays: String, Identifiable, CaseIterable {
    case sunday, monday, tuesday, wednesday, thursday, friday, saturday
    
    var id: Self { self }
    
    var today: Self {
        let index = Calendar.current.component(.weekday, from: Date())
        return Weekdays.allCases[index]
    }
    
    static func day(index: Int) -> Self {
        return Weekdays.allCases[index]
    }
    
    var shortName: String {
        let text = self.rawValue
        let endIndex = text.index(text.startIndex, offsetBy: 3)
        return String(text.capitalized[..<endIndex])
    }
}

struct WeatherDetail: View {
    @EnvironmentObject var viewModel: WeatherViewModel
    let weather: DailyWeatherResponse
    @State private var showingDeleteDialog = false
    @State private var imageURL: URL? = nil
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView(showsIndicators: false) {
                ZStack {
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
//                            .clipped()
                    } placeholder: {
                        ProgressView()
                    }
                    VStack {
                        Text(getName(for: weather.coord))
                            .font(.title2)
                        Text("\(weather.daily.first!.temp.day)")
                            .font(.largeTitle)
                            .bold()
                        Text("\(weather.daily.first!.weather.first!.description)")
                    }
                }
                HStack {
                    VStack {
                        Image(systemName: "wind")
                            .resizable()
                            .frame(width: 60, height: 60)
                        Text("\(weather.daily.first!.windSpeed)")
                        Text("Wind")
                    }
                    Spacer()
                    VStack {
                        Image(systemName: "cloud.rain")
                            .resizable()
                            .frame(width: 60, height: 60)
                        Text("\(weather.daily.first!.rain ?? 0)%")
                        Text("Rain")
                    }
                    Spacer()
                    VStack {
                        Image(systemName: "wind")
                            .resizable()
                            .frame(width: 60, height: 60)
                        Text("\(weather.daily.first!.humidity)")
                        Text("Humidity")
                    }
                }
                .padding(.horizontal)
                Divider()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(weather.daily) { day in
                            VStack {
                                Text("\(weekday(from: day.date).shortName)")
                                Image(systemName: iconName(for: day.weather.first!.id))
                                Text("\(day.temp.day)ºC")
                            }
                            Spacer()
                        }
                    }
                }
                Spacer()
            }
            .navigationBarHidden(true)
            .task {
                guard let photos = await NetworkManager.loadImage(name: getName(for: weather.coord)) else {
                    return
                }
                imageURL = photos.results.first!.urls.regular
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
            
            HStack {
                Button("Back") {
                    dismiss()
                }
                Spacer()
                Button("Delete") {
                    showingDeleteDialog = true
                }
            }
        }
    }
}

private extension WeatherDetail {
    func weekday(from date: Date) -> Weekdays {
        let index = Calendar.current.component(.weekday, from: date) - 1
        return Weekdays.day(index: index)
    }
    var deleteButton: some View {
        Button {
            showingDeleteDialog = true
        } label: {
            Image(systemName: "trash")
        }
    }
    
    func getName(for location: Coordinates) -> String {
        guard let item = viewModel.locations.first(where: { $0.coord == location }) else {
            return "N/A"
        }
        return item.name
    }
}

struct WeatherDetail_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetail(weather: DailyWeatherResponse.example)
            .environmentObject(WeatherViewModel())
    }
}
