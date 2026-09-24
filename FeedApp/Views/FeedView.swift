//
//  FeedView.swift
//  FeedApp
//
//  Created by Iren Poghosyan on 22.09.26.
//

import SwiftUI

struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()

    private let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 2) {
                    ForEach(displayedPhotos) { photo in
                        NavigationLink {
                            PhotoDetailView(photo: photo)
                        } label: {
                            CachedAsyncImage(urlString: photo.urls.small)
                                .aspectRatio(1, contentMode: .fill)
                                .clipped()
                        }
                        .buttonStyle(.plain)
                        .task {
                            guard !viewModel.isShowingSearchResults else { return }
                            await viewModel.loadMoreIfNeeded(currentItem: photo)
                        }
                    }
                }

                if viewModel.isLoading || viewModel.isSearching {
                    ProgressView()
                        .padding()
                }

                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding()
                }

                if viewModel.isShowingSearchResults && viewModel.searchResults.isEmpty && !viewModel.isSearching {
                    Text("No photos found")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding()
                }
            }
            .navigationTitle("Feed")
            .searchable(text: $viewModel.searchQuery, prompt: "Search photos")
            .task {
                await viewModel.loadInitialPhotos()
            }
            .task(id: viewModel.searchQuery) {
                guard viewModel.isShowingSearchResults else { return }
                try? await Task.sleep(nanoseconds: 300_000_000)
                guard !Task.isCancelled else { return }
                await viewModel.performSearch()
            }
            .refreshable {
                if viewModel.isShowingSearchResults {
                    await viewModel.performSearch()
                } else {
                    await viewModel.refresh()
                }
            }
        }
    }

    private var displayedPhotos: [Photo] {
        viewModel.isShowingSearchResults ? viewModel.searchResults : viewModel.photos
    }
}
