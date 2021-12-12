//
//  View+RoundedThinMaterial.swift
//  Weather
//
//  Created by Tino on 12/12/21.
//

import SwiftUI

struct RoundedThinMaterial: ViewModifier {
    let cornerRadius: Double
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(cornerRadius)
    }
}

extension View {
    func roundedThinMaterial(cornerRadius: Double = 20.0) -> some View {
        modifier(RoundedThinMaterial(cornerRadius: cornerRadius))
    }
}
