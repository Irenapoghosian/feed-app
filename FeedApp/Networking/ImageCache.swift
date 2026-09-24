//
//  ImageCache.swift
//  FeedApp
//
//  Created by Iren Poghosyan on 22.09.26.
//

import UIKit

final class ImageCache {
    static let shared = ImageCache()

    private let memoryCache = NSCache<NSString, UIImage>()
    private let diskCacheURL: URL
    private let fileManager = FileManager.default

    private init() {
        let caches = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        diskCacheURL = caches.appendingPathComponent("ImageCache", isDirectory: true)
        try? fileManager.createDirectory(at: diskCacheURL, withIntermediateDirectories: true)
        memoryCache.countLimit = 200
    }

    private func diskURL(for key: String) -> URL {
        let filename = String(key.hashValue)
        return diskCacheURL.appendingPathComponent(filename)
    }

    func image(for key: String) -> UIImage? {
        if let cached = memoryCache.object(forKey: key as NSString) {
            return cached
        }
        let url = diskURL(for: key)
        if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            memoryCache.setObject(image, forKey: key as NSString)
            return image
        }
        return nil
    }

    func store(_ image: UIImage, for key: String) {
        memoryCache.setObject(image, forKey: key as NSString)
        let url = diskURL(for: key)
        if let data = image.jpegData(compressionQuality: 0.85) {
            try? data.write(to: url)
        }
    }
}
