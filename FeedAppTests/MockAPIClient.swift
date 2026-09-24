//
//  Untitled.swift
//  FeedApp
//
//  Created by Iren Poghosyan on 24.09.26.
//

import Foundation
@testable import FeedApp

final class MockAPIClient: PhotoFetching {
    var pagesToReturn: [[Photo]] = []
    var searchResultsToReturn: [Photo] = []
    var errorToThrow: Error?
    private(set) var requestedPages: [Int] = []
    private(set) var searchedQueries: [String] = []

    func fetchPhotos(page: Int, perPage: Int) async throws -> [Photo] {
        requestedPages.append(page)
        if let errorToThrow {
            throw errorToThrow
        }
        let index = page - 1
        guard index >= 0, index < pagesToReturn.count else {
            return []
        }
        return pagesToReturn[index]
    }

    func searchPhotos(query: String, page: Int, perPage: Int) async throws -> [Photo] {
        searchedQueries.append(query)
        if let errorToThrow {
            throw errorToThrow
        }
        return searchResultsToReturn
    }
}

extension Photo {
    static func stub(id: String) -> Photo {
        Photo(
            id: id,
            width: 100,
            height: 100,
            description: nil,
            altDescription: nil,
            urls: Photo.PhotoURLs(
                raw: "https://example.com/raw",
                full: "https://example.com/full",
                regular: "https://example.com/regular",
                small: "https://example.com/small",
                thumb: "https://example.com/thumb"
            ),
            user: Photo.PhotoUser(name: "Test User", username: "testuser"),
            likes: 0
        )
    }
}
