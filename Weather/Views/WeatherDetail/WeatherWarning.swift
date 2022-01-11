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
            if weather.hasAlert {
                Text(weather.alertEvent!)
                
                if showMore {
                    ScrollView {
                        VStack(alignment: .leading) {
                            Text("From: \(weather.formattedAlertStartDate)")
                            Text("To: \(weather.formattedAlertEndDate)")
                            Text("By: \(weather.alertSenderName!)")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Divider()
                        Text(weather.alerts!.first!.description)
                            .textSelection(.enabled)
                    }
                    .frame(maxHeight: 200, alignment: .leading)
                    
                }
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
