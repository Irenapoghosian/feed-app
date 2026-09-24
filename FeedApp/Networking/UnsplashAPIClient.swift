//
//  UnsplashAPIClient.swift
//  FeedApp
//
//  Created by Iren Poghosyan on 22.09.26.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid request URL."
        case .invalidResponse: return "Server returned an unexpected response."
        case .decodingFailed: return "Could not parse the response."
        }
    }
}

private struct SearchPhotosResponse: Codable {
    let results: [Photo]
}

actor UnsplashAPIClient {
    private let baseURL = "https://api.unsplash.com"
    private let session = URLSession.shared

    func fetchPhotos(page: Int, perPage: Int = 20) async throws -> [Photo] {
        var components = URLComponents(string: "\(baseURL)/photos")
        components?.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)"),
            URLQueryItem(name: "client_id", value: Secrets.unsplashAccessKey)
        ]

        let data = try await performRequest(components: components)
        return try decode([Photo].self, from: data)
    }

    func searchPhotos(query: String, page: Int, perPage: Int = 20) async throws -> [Photo] {
        var components = URLComponents(string: "\(baseURL)/search/photos")
        components?.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)"),
            URLQueryItem(name: "client_id", value: Secrets.unsplashAccessKey)
        ]

        let data = try await performRequest(components: components)
        let response = try decode(SearchPhotosResponse.self, from: data)
        return response.results
    }

    private func performRequest(components: URLComponents?) async throws -> Data {
        guard let url = components?.url else { throw APIError.invalidURL }

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            let code = (response as? HTTPURLResponse)?.statusCode ?? -1
            let body = String(data: data, encoding: .utf8) ?? "no body"
            print("Unsplash API error \(code): \(body)")
            throw APIError.invalidResponse
        }

        return data
    }

    private func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            throw APIError.decodingFailed
        }
    }
}
