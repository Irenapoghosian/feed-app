//
//  Photo.swift
//  FeedApp
//
//  Created by Iren Poghosyan on 22.09.26.
//

import Foundation

struct Photo: Codable, Identifiable, Equatable {
    let id: String
    let width: Int
    let height: Int
    let description: String?
    let altDescription: String?
    let urls: PhotoURLs
    let user: PhotoUser
    let likes: Int

    struct PhotoURLs: Codable, Equatable {
        let raw: String
        let full: String
        let regular: String
        let small: String
        let thumb: String
    }

    struct PhotoUser: Codable, Equatable {
        let name: String
        let username: String
    }

    enum CodingKeys: String, CodingKey {
        case id, width, height, description, urls, user, likes
        case altDescription = "alt_description"
    }
}
