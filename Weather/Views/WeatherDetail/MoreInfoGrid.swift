//
//  HeaderRow.swift
//  Weather
//
//  Created by Tino on 12/12/21.
//

import SwiftUI

struct InfoItem<V>: View where V: View {
    var systemName: String
    var title: String
    var content: () -> V
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: systemName)
                    .symbolRenderingMode(.multicolor)
                Text(title)
            }
            .foregroundColor(Color("text"))
            .frame(maxWidth:.infinity, alignment: .leading)
            .font(.title)
            
            content()
            
            Spacer()
        }
        .padding()
//        .frame(width: 200, height: 200)
        .ultraThinMaterialShadow()
        .cornerRadius(15)
    }
}

struct Centered: ViewModifier {
    func body(content: Content) -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                content
                Spacer()
            }
            Spacer()
        }
    }
}

extension View {
    func centered() -> some View {
        modifier(Centered())
    }
}

struct MoreInfoGrid: View {
    let weather: DailyWeatherResponse
    let iconWidth = 60.0
    let iconHeight = 60.0
    
    var body: some View {
        VStack {
            HStack {
                InfoItem(systemName: "humidity.fill", title: "Humidity") {
                    Text("\(weather.humidity)")
                        .font(.system(size: 50))
                        .foregroundColor(Color("text"))
                        .centered()
                }
                InfoItem(systemName: "cloud.rain.fill", title: "Rain") {
                    Text("\(weather.pop)")
                        .font(.system(size: 50))
                        .foregroundColor(Color("text"))
                        .centered()
                }
            }
            HStack {
                InfoItem(systemName: "wind", title: "Wind Speed") {
                    Text("\(weather.windSpeed)")
                        .foregroundColor(Color("text"))
                        .font(.system(size: 50))
                        .centered()
                }
                InfoItem(systemName: "wind", title: "Wind direction") {
                    Text("\(weather.windDeg)")
                        .foregroundColor(Color("text"))
                        .font(.system(size: 50))
                        .centered()
                }
            }
            
        }
    }
}

struct HeaderRow_Previews: PreviewProvider {
    static var previews: some View {
        MoreInfoGrid(weather: DailyWeatherResponse.example)
    }
}
