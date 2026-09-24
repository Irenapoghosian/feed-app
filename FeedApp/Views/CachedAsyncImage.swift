//
//  CachedAsyncImage.swift
//  FeedApp
//
//  Created by Iren Poghosyan on 22.09.26.
//

import SwiftUI

struct CachedAsyncImage: View {
    let urlString: String

    @State private var image: UIImage?
    @State private var isLoading = false

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.15))
                    .overlay {
                        if isLoading {
                            ProgressView()
                        }
                    }
            }
        }
        .task(id: urlString) {
            await load()
        }
    }

    private func load() async {
        if let cached = ImageCache.shared.image(for: urlString) {
            image = cached
            return
        }
        guard let url = URL(string: urlString) else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let downloaded = UIImage(data: data) {
                ImageCache.shared.store(downloaded, for: urlString)
                image = downloaded
            }
        } catch {
            // Leave placeholder on failure
        }
    }
}
