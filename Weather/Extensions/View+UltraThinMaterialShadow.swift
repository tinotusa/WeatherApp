//
//  View+UltraThinMaterialShadow.swift
//  Weather
//
//  Created by Tino on 5/1/22.
//

import SwiftUI

struct UltraThinMatrialShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
    }
}

extension View {
    func ultraThinMaterialShadow() -> some View {
        modifier(UltraThinMatrialShadow())
    }
}
