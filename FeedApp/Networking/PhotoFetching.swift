//
//  PhotoFetching.swift
//  FeedApp
//
//  Created by Iren Poghosyan on 24.09.26.
//

import Foundation

protocol PhotoFetching {
    func fetchPhotos(page: Int, perPage: Int) async throws -> [Photo]
    func searchPhotos(query: String, page: Int, perPage: Int) async throws -> [Photo]
}

extension PhotoFetching {
    func fetchPhotos(page: Int) async throws -> [Photo] {
        try await fetchPhotos(page: page, perPage: 20)
    }

    func searchPhotos(query: String, page: Int) async throws -> [Photo] {
        try await searchPhotos(query: query, page: page, perPage: 20)
    }
}

extension UnsplashAPIClient: PhotoFetching {}
