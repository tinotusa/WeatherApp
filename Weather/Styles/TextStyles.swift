//
//  TextStyles.swift
//  Weather
//
//  Created by Tino on 7/1/22.
//

import SwiftUI

struct SmallFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title3)
    }
}

struct RowFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2)
    }
}

struct BodyFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
    }
}

struct RowTitleFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
    }
}

struct LargeFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 50))
    }
}

extension View {
    func smallFont() -> some View {
        modifier(SmallFont())
    }
    
    func rowFont() -> some View {
        modifier(RowFont())
    }
    
    func bodyFont() -> some View {
        modifier(BodyFont())
    }
    
    func rowTitleFont() -> some View {
        modifier(RowTitleFont())
    }
    
    func largeFont() -> some View {
        modifier(LargeFont())
    }
}

struct TextStyles: View {
    var body: some View {
        VStack {
            Text("Weather row alert")
                .smallFont()
            
            Text("Row text")
                .rowFont()
            
            Text("Normal")
                .bodyFont()
            
            Text("Weather Row Title")
                .rowTitleFont()
            
            Text("Weather temp")
                .largeFont()
            
        }
    }
}

struct TextStyles_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.opacity(0.3)
            TextStyles()
        }
    }
}
