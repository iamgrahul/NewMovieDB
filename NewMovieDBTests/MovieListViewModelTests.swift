//
//  MovieListViewModelTests.swift
//  NewMovieDB
//
//  Created by Apple on 02/07/25.
//

import XCTest
@testable import NewMovieDB

final class MovieListViewModelTests: XCTestCase {

    private var viewModel: MovieListViewModel!
    private var mockService: MockMovieService!
    private var mockCoordinator: MockCoordinator!
    let mockMovie = Movie(id: 1003, title: "title", overview: "Overview", releaseDate: "2023-01-01", posterPath: "/test.jpg")
    // MARK: - Setup and Teardown

    override func setUp() {
        super.setUp()
        mockService = MockMovieService()
        viewModel = MovieListViewModel(service: mockService)
        mockCoordinator = MockCoordinator()
        viewModel.coordinator = mockCoordinator
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        mockCoordinator = nil
        super.tearDown()
    }

    // MARK: - Tests
    func testLoadMoviesSuccessfully() async throws {
        mockService.moviesToReturn = [mockMovie]
        try await viewModel.loadMovies()
        XCTAssertEqual(viewModel.movies.count, 1)
        XCTAssertEqual(viewModel.movies.first?.title, "title")
    }

    func testLoadMoviesFailureThrows() async {
        mockService.shouldFail = true
        do {
            _ = try await viewModel.loadMovies()
            XCTFail("Expected error not thrown")
        } catch {
            XCTAssertTrue(true)
        }
    }

    func testMovieAtIndexReturnsCorrectMovie() async throws {
        mockService.moviesToReturn = [mockMovie]
        try await viewModel.loadMovies()
        let result = try viewModel.movie(at: 0)
        XCTAssertEqual(result.id, 1003)
    }

    func test_didSelect_shouldCallCoordinator() {
        viewModel.didSelect(movie: mockMovie)
        XCTAssertEqual(mockCoordinator.receivedMovie, mockMovie)
    }
}

class MockCoordinator: MovieCoordinator {
    var didNavigateToDetail = false
    var receivedMovie: Movie?

    override func showMovieDetail(movie: Movie) {
        didNavigateToDetail = true
        receivedMovie = movie
    }
}
