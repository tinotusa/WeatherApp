//
//  WeatherRow.swift
//  Weather
//
//  Created by Tino on 4/12/21.
//

import SwiftUI



struct WeatherRow: View {
    struct Constants {
        static let width = 50.0
        static let height = 50.0
    }
    
    let location: GeoResponse
    let colours: [Color] = [.red, .green, .blue]
    @State private var weather: WeatherResponse = WeatherResponse.invalidResponse
    @State private var icon: Image? = Image(systemName: "xmark")

    var body: some View {
        NavigationLink(destination: Text("\(location.name) detail")) {
            ZStack(alignment: .bottomLeading) {
                colours.randomElement()!.opacity(Double.random(in: 0 ..< 1))
                    .frame(height: 146)
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Text(location.name)
                            .font(.largeTitle)
                            .foregroundColor(Color("text"))
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            HStack {
                                if icon != nil {
                                    icon!
                                        .resizable()
                                        .frame(width: Constants.width, height: Constants.height)
                                }
                                Text(formattedTemp(weather.main.temp))
                                    .font(.largeTitle)
                            }
                            Spacer()
                            
                            Text("Min: \(formattedTemp(weather.main.tempMin))")
                            Text("Max: \(formattedTemp(weather.main.tempMax))")
                            
                        }
                    }
                }
                .padding()
                .foregroundColor(Color("text"))
            }
        }
        .task {
            weather = await NetworkManager.loadCurrentWeather(for: location.text)
            guard weather.weather.first != nil else {
                print("Error: Weather response has not weather struct")
                return
            }
            let iconUIImage = await NetworkManager.loadIcon(name: weather.weather.first!.icon)
            if iconUIImage != nil {
                icon = Image(uiImage: iconUIImage!)
            }
        }
    }
}

private extension WeatherRow {
    func formattedTemp(_ temp: Double) -> String {
        let unit = Locale.current.usesMetricSystem ? "C" : "F"
        return String(format: "%.0fº\(unit)", temp)
    }
}


struct WeatherRow_Previews: PreviewProvider {
    static var previews: some View {
        WeatherRow(location: GeoResponse.example)
            .previewLayout(.fixed(width: 560.0, height: 150.0))
            .background(.gray)
    }
}
