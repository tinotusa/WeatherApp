//
//  Weekdays.swift
//  Weather
//
//  Created by Tino on 12/12/21.
//

import Foundation

enum Weekday: String, Identifiable, CaseIterable {
    case sunday, monday, tuesday, wednesday, thursday, friday, saturday
    
    var id: Self { self }
    
    var today: Self {
        let index = Calendar.current.component(.weekday, from: Date())
        return Weekday.allCases[index]
    }
    
    static func day(index: Int) -> Self {
        return Weekday.allCases[index]
    }
    
    static func weekday(from date: Date) -> Self {
        let index = Calendar.current.component(.weekday, from: date) - 1
        return day(index: index)
    }
    
    var shortName: String {
        let text = self.rawValue
        let endIndex = text.index(text.startIndex, offsetBy: 3)
        return String(text.capitalized[..<endIndex])
    }
}
