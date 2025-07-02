//
//  MovieListViewModelTests.swift
//  NewMovieDB
//
//  Created by Apple on 02/07/25.
//

import XCTest
@testable import NewMovieDB

final class MovieListViewModelTests: XCTestCase {

    func testLoadMoviesSuccessfully() async throws {
        let mockService = MockMovieService()
        mockService.moviesToReturn = [
            Movie(id: 1, title: "Test", overview: "Test overview", releaseDate: "2024", posterPath: "")
        ]
        let viewModel = MovieListViewModel(service: mockService)

        try await viewModel.loadMovies()
        XCTAssertEqual(viewModel.movies.count, 1)
        XCTAssertEqual(viewModel.movies.first?.title, "Test")
    }

    func testLoadMoviesFailureThrows() async {
        let mockService = MockMovieService()
        mockService.shouldFail = true
        let viewModel = MovieListViewModel(service: mockService)

        do {
            _ = try await viewModel.loadMovies()
            XCTFail("Expected error not thrown")
        } catch {
            XCTAssertTrue(true)
        }
    }

    func testMovieAtIndexReturnsCorrectMovie() async throws {
        let movie = Movie(id: 42, title: "Sample", overview: "Details", releaseDate: "2025", posterPath: "")
        let mockService = MockMovieService()
        mockService.moviesToReturn = [movie]
        let viewModel = MovieListViewModel(service: mockService)

        try await viewModel.loadMovies()
        let result = viewModel.movie(at: 0)
        XCTAssertEqual(result.id, 42)
    }

    func testDidSelectMovieCallsCoordinator() {
        let mockService = MockMovieService()
        let mockCoordinator = MockCoordinator(navigationController: UINavigationController())
        let viewModel = MovieListViewModel(service: mockService)
        viewModel.coordinator = mockCoordinator

        let movie = Movie(id: 7, title: "Selected", overview: "Movie overview", releaseDate: "2024", posterPath: "")
        viewModel.didSelect(movie: movie)

        XCTAssertTrue(mockCoordinator.didNavigateToDetail)
        XCTAssertEqual(mockCoordinator.receivedMovie?.id, movie.id)
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
