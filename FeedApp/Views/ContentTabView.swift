//
//  ContentTabView.swift
//  FeedApp
//
//  Created by Iren Poghosyan on 24.09.26.
//

import SwiftUI

struct ContentTabView: View {
    var body: some View {
        TabView {
            FeedView()
                .tabItem {
                    Label("Feed", systemImage: "photo.on.rectangle")
                }

            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
        }
    }
}
