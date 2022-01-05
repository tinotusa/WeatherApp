//
//  WeatherWarning.swift
//  Weather
//
//  Created by Tino on 5/1/22.
//

import SwiftUI

struct WeatherWarning: View {
    let weather: DailyWeatherResponse
    @State private var showMore = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Label("Warning", systemImage: "exclamationmark.triangle.fill")
                    .symbolRenderingMode(.multicolor)
                
                Spacer()
            
                Button {
                    withAnimation {
                        showMore.toggle()
                    }
                } label: {
                    Label(
                        showMore ? "Show less" : "Show more",
                        systemImage: showMore ? "chevron.up" : "chevron.down")
                }
            }
            
            Text(weather.alerts!.first!.event)
            
            if showMore {
                ScrollView(showsIndicators: false) {
                    Text(weather.alerts!.first!.description)
                        .textSelection(.enabled)
                }
                .frame(maxHeight: 200)
            }
        }
        .padding()
        .ultraThinMaterialShadow()
        .cornerRadius(15)
    }
}

//struct WeatherWarning_Previews: PreviewProvider {
//    static var previews: some View {
//        WeatherWarning(weather: DailyWeatherResponse.example)
//    }
//}
