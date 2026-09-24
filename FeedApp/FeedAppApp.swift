//
//  FeedAppApp.swift
//  FeedApp
//
//  Created by Iren Poghosyan on 22.09.26.
//

import SwiftUI

@main
struct FeedAppApp: App {
    @StateObject private var favoritesStore = FavoritesStore()

    var body: some Scene {
        WindowGroup {
            ContentTabView()
                .environmentObject(favoritesStore)
        }
    }
}
