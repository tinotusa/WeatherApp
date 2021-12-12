//
//  Color+HexInit.swift
//  Weather
//
//  Created by Tino on 12/12/21.
//

import SwiftUI

extension Color {
    init(hex hexString: String) {
        // #ffffff
        let hexString = Array(hexString)
        var components = [Double]()
        for i in stride(from: 1, to: 6, by: 2) {
            let text = String(hexString[i ..< i + 2])
            let value = Double(Int(text, radix: 16)!)
            components.append(value / 255.0)
        }
        self.init(
            red: components[0],
            green: components[1],
            blue: components[2]
        )
    }
}
