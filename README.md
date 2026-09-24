# FeedApp

An Instagram-style photo feed app built with SwiftUI, powered by the Unsplash API.

## Features

- Infinite-scroll photo feed with pagination
- Custom two-tier image caching (in-memory + disk)
- Photo detail view with photographer info, likes, and description
- Pull-to-refresh
- MVVM architecture with an actor-based networking layer

## Tech Stack

- SwiftUI
- Swift Concurrency (async/await)
- MVVM
- Unsplash REST API
- Custom NSCache + FileManager-based disk cache

## Setup

1. Get a free API key from Unsplash Developers (unsplash.com/developers)
2. Create FeedApp/Config/Secrets.swift with your access key
3. Build and run in Xcode
