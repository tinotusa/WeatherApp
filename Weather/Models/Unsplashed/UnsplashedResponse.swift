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

struct UnsplashedProfileImage: Codable {
    var small: URL
}

struct UnslplashedUserLinks: Codable {
    var html: URL
}

struct UnsplashedUser: Codable, Identifiable {
    var id: String
    var name: String
    var profileImage: UnsplashedProfileImage
    var links: UnslplashedUserLinks
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
        case id, name, links
    }
}

struct UnsplashedPhoto: Codable, Identifiable {
    let id: String
    let user: UnsplashedUser
    let color: String
    let urls: UnsplashedPhotoURLS
}

struct UnsplashedSearchResponse: Codable {
    let total: Int
    let results: [UnsplashedPhoto]
}
