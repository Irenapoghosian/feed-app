//
//  FavoritesStore.swift
//  FeedApp
//
//  Created by Iren Poghosyan on 24.09.26.
//

import Foundation
import Combine

@MainActor
final class FavoritesStore: ObservableObject {
    @Published private(set) var favoritePhotos: [Photo] = []

    private let defaultsKey = "favoritePhotos"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        load()
    }

    func isFavorite(_ photo: Photo) -> Bool {
        favoritePhotos.contains { $0.id == photo.id }
    }

    func toggleFavorite(_ photo: Photo) {
        if let index = favoritePhotos.firstIndex(where: { $0.id == photo.id }) {
            favoritePhotos.remove(at: index)
        } else {
            favoritePhotos.insert(photo, at: 0)
        }
        save()
    }

    private func load() {
        guard let data = defaults.data(forKey: defaultsKey) else { return }
        favoritePhotos = (try? JSONDecoder().decode([Photo].self, from: data)) ?? []
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(favoritePhotos) else { return }
        defaults.set(data, forKey: defaultsKey)
    }
}
