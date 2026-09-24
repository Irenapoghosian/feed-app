//
//  PhotoDetailView.swift
//  FeedApp
//
//  Created by Iren Poghosyan on 24.09.26.
//

import SwiftUI

struct PhotoDetailView: View {
    let photo: Photo
    @EnvironmentObject private var favoritesStore: FavoritesStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                CachedAsyncImage(urlString: photo.urls.regular)
                    .aspectRatio(CGFloat(photo.width) / CGFloat(photo.height), contentMode: .fit)
                    .frame(maxWidth: .infinity)
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(photo.user.name)
                                .font(.headline)
                            Text("@\(photo.user.username)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        HStack(spacing: 4) {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                            Text("\(photo.likes)")
                                .font(.subheadline)
                        }
                    }

                    if let description = photo.description ?? photo.altDescription {
                        Text(description)
                            .font(.body)
                            .foregroundColor(.primary)
                    }

                    Text("Photo by \(photo.user.name) on Unsplash")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Photo")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    favoritesStore.toggleFavorite(photo)
                } label: {
                    Image(systemName: favoritesStore.isFavorite(photo) ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
}
