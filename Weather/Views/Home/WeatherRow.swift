//
//  WeatherRow.swift
//  Weather
//
//  Created by Tino on 4/12/21.
//

import SwiftUI

struct WeatherRow: View {
    let location: GeoResponse
    let colours: [Color] = [.red, .green, .blue]
    var body: some View {
        NavigationLink(destination: Text("\(location.name) detail")) {
            ZStack(alignment: .bottomLeading) {
                colours.randomElement()!.opacity(Double.random(in: 0 ..< 1))
                    .frame(height: 146)
                VStack(alignment: .leading) {
                    Text(location.name)
                        .font(.largeTitle)
                        .foregroundColor(Color("text"))
                    Text("23ºC")
                        .font(.title2)
                }
                .padding()
                .foregroundColor(Color("text"))
            }
        }
    }
}

struct WeatherRow_Previews: PreviewProvider {
    static var previews: some View {
        WeatherRow(location: GeoResponse.example)
    }
}
