//
//  UnsplashedResponse.swift
//  Weather
//
//  Created by Tino on 24/12/21.
//

import Foundation

struct UnsplashedPhotoURLS: Codable {
    let raw: URL
    let full: URL
    let regular: URL
    let small: URL
    let thumb: URL
}

struct UnsplashedPhoto: Codable, Identifiable {
    let id: String
    let width: Int
    let height: Int
    let color: String
    let urls: UnsplashedPhotoURLS
}

struct UnsplashedSearchResponse: Codable {
    let total: Int
    let results: [UnsplashedPhoto]
}
