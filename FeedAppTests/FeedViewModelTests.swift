//
//  FeedViewModelTests.swift
//  FeedApp
//
//  Created by Iren Poghosyan on 24.09.26.
//

import XCTest
@testable import FeedApp

@MainActor
final class FeedViewModelTests: XCTestCase {
    
    func test_loadInitialPhotos_populatesPhotos() async {
        let mock = MockAPIClient()
        mock.pagesToReturn = [[Photo.stub(id: "1"), Photo.stub(id: "2")]]
        let viewModel = FeedViewModel(apiClient: mock)
        
        await viewModel.loadInitialPhotos()
        
        XCTAssertEqual(viewModel.photos.map(\.id), ["1", "2"])
        XCTAssertEqual(mock.requestedPages, [1])
    }
    
    func test_loadInitialPhotos_doesNothing_whenPhotosAlreadyLoaded() async {
        let mock = MockAPIClient()
        mock.pagesToReturn = [[Photo.stub(id: "1")], [Photo.stub(id: "2")]]
        let viewModel = FeedViewModel(apiClient: mock)

        await viewModel.loadInitialPhotos()
        await viewModel.loadInitialPhotos()

        XCTAssertEqual(mock.requestedPages, [1])
        XCTAssertEqual(viewModel.photos.map(\.id), ["1"])
    }
    
    func test_loadMoreIfNeeded_appendsNextPage_whenLastItemVisible() async {
        let mock = MockAPIClient()
        mock.pagesToReturn = [
            [Photo.stub(id: "1"), Photo.stub(id: "2")],
            [Photo.stub(id: "3"), Photo.stub(id: "4")]
        ]
        let viewModel = FeedViewModel(apiClient: mock)
        await viewModel.loadInitialPhotos()

        let lastPhoto = viewModel.photos.last!
        await viewModel.loadMoreIfNeeded(currentItem: lastPhoto)

        XCTAssertEqual(viewModel.photos.map(\.id), ["1", "2", "3", "4"])
        XCTAssertEqual(mock.requestedPages, [1, 2])
    }
    
    func test_loadMoreIfNeeded_doesNothing_whenNotLastItem() async {
        let mock = MockAPIClient()
        mock.pagesToReturn = [
            [Photo.stub(id: "1"), Photo.stub(id: "2")],
            [Photo.stub(id: "3")]
        ]
        let viewModel = FeedViewModel(apiClient: mock)
        await viewModel.loadInitialPhotos()

        let firstPhoto = viewModel.photos.first!
        await viewModel.loadMoreIfNeeded(currentItem: firstPhoto)

        XCTAssertEqual(viewModel.photos.map(\.id), ["1", "2"])
        XCTAssertEqual(mock.requestedPages, [1])
    }
    
    func test_pagination_stops_whenEmptyPageReturned() async {
        let mock = MockAPIClient()
        mock.pagesToReturn = [[Photo.stub(id: "1")], []]
        let viewModel = FeedViewModel(apiClient: mock)
        await viewModel.loadInitialPhotos()

        let lastPhoto = viewModel.photos.last!
        await viewModel.loadMoreIfNeeded(currentItem: lastPhoto)
        await viewModel.loadMoreIfNeeded(currentItem: lastPhoto)

        XCTAssertEqual(viewModel.photos.map(\.id), ["1"])
        XCTAssertEqual(mock.requestedPages, [1, 2])
    }
    
    func test_refresh_resetsPageAndReloads() async {
        let mock = MockAPIClient()
        mock.pagesToReturn = [
            [Photo.stub(id: "1"), Photo.stub(id: "2")],
            [Photo.stub(id: "3")]
        ]
        let viewModel = FeedViewModel(apiClient: mock)
        await viewModel.loadInitialPhotos()
        await viewModel.loadMoreIfNeeded(currentItem: viewModel.photos.last!)

        mock.pagesToReturn = [[Photo.stub(id: "9")]]
        await viewModel.refresh()

        XCTAssertEqual(viewModel.photos.map(\.id), ["9"])
    }
    
    func test_loadPhotos_setsErrorMessage_onFailure() async {
        let mock = MockAPIClient()
        mock.errorToThrow = APIError.invalidResponse
        let viewModel = FeedViewModel(apiClient: mock)

        await viewModel.loadInitialPhotos()

        XCTAssertTrue(viewModel.photos.isEmpty)
        XCTAssertNotNil(viewModel.errorMessage)
    }
}
