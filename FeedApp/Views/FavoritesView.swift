//
//  FavoritesView.swift
//  FeedApp
//
//  Created by Iren Poghosyan on 24.09.26.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var favoritesStore: FavoritesStore

    private let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]

    var body: some View {
        NavigationStack {
            Group {
                if favoritesStore.favoritePhotos.isEmpty {
                    ContentUnavailableView(
                        "No Favorites Yet",
                        systemImage: "heart",
                        description: Text("Tap the heart on a photo to save it here.")
                    )
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 2) {
                            ForEach(favoritesStore.favoritePhotos) { photo in
                                NavigationLink {
                                    PhotoDetailView(photo: photo)
                                } label: {
                                    CachedAsyncImage(urlString: photo.urls.small)
                                        .aspectRatio(1, contentMode: .fill)
                                        .clipped()
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
        }
    }
}
