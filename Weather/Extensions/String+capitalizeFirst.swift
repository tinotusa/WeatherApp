//
//  String+capitalizeFirst.swift
//  Weather
//
//  Created by Tino on 12/12/21.
//

import Foundation

extension String {
    var capitalizeFirst: String {
        if isEmpty {
            return self
        }
        let firstLetter = self[startIndex ... startIndex]
        return firstLetter.uppercased() + self[self.index(after: startIndex)...]
    }
}
