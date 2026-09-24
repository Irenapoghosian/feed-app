//
//  FeedViewModel.swift
//  FeedApp
//
//  Created by Iren Poghosyan on 22.09.26.
//

import Foundation
import Combine

@MainActor
final class FeedViewModel: ObservableObject {
    @Published var photos: [Photo] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    @Published var searchQuery = ""
    @Published var searchResults: [Photo] = []
    @Published var isSearching = false

    private let apiClient: PhotoFetching
    private var currentPage = 1
    private var canLoadMore = true

    init(apiClient: PhotoFetching = UnsplashAPIClient()) {
        self.apiClient = apiClient
    }

    var isShowingSearchResults: Bool {
        !searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func loadInitialPhotos() async {
        guard photos.isEmpty else { return }
        await loadPhotos(reset: true)
    }

    func loadMoreIfNeeded(currentItem: Photo) async {
        guard let last = photos.last, last.id == currentItem.id,
              canLoadMore, !isLoading else { return }
        await loadPhotos(reset: false)
    }

    func refresh() async {
        currentPage = 1
        canLoadMore = true
        await loadPhotos(reset: true)
    }

    func performSearch() async {
        let trimmed = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            searchResults = []
            return
        }

        isSearching = true
        errorMessage = nil
        defer { isSearching = false }

        do {
            searchResults = try await apiClient.searchPhotos(query: trimmed, page: 1)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadPhotos(reset: Bool) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let newPhotos = try await apiClient.fetchPhotos(page: currentPage)
            if newPhotos.isEmpty {
                canLoadMore = false
            } else {
                photos = reset ? newPhotos : photos + newPhotos
                currentPage += 1
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
