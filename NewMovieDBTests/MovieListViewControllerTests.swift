//
//  MovieListViewControllerTests.swift
//  MovieListViewControllerTests
//
//  Created by Apple on 19/06/25.
//

import XCTest

@testable import NewMovieDB

final class MovieListViewControllerTests: XCTestCase {
    var viewModel: MovieListViewModel!
    var vc: MovieListViewController!
    var mockService: MockMovieService!
    var mockMovie: Movie!

    override func setUp() {
        mockService = MockMovieService()
        viewModel = MovieListViewModel(service:mockService)
        vc = MovieListViewController(viewModel: viewModel)
        mockMovie = Movie(id: 1,
                          title: "Movie Test",
                          overview: "Overview",
                          releaseDate: "2023",
                          posterPath: "")
        mockService.moviesToReturn = [
            mockMovie
        ]
    }

    func testViewController_Initialization() {
        XCTAssertNotNil(viewModel)
        XCTAssertNotNil(vc)
        XCTAssertNotNil(mockService)
        XCTAssertNotNil(mockMovie)
    }

    func testViewController_TitleIsSet() {
        _ = vc.view // trigger viewDidLoad
        XCTAssertEqual(vc.title, "Movies")
    }

    func testTableView_NumberOfRowsAfterLoading() async {
        await vc.loadViewIfNeeded()

        // Load data
        await vc.performLoadMovies()

        let numberOfRows = await vc.tableView.numberOfRows(inSection: 0)
        XCTAssertEqual(numberOfRows, 1)
    }

    func testTableView_CellContent() async {
        await vc.loadViewIfNeeded()
        await vc.performLoadMovies()
        let cellText = await MainActor.run { () -> String? in
            let indexPath = IndexPath(row: 0, section: 0)
            let cell = vc.tableView.dataSource?.tableView(vc.tableView, cellForRowAt: indexPath)
            return cell?.textLabel?.text
        }
        XCTAssertEqual(cellText, mockMovie.title)
    }

    func testLoadMovies_WhenServiceFails_DoesNotCrash() async {
        mockService.shouldFail = true

        await vc.loadViewIfNeeded()

        // This should not throw or crash
        await vc.performLoadMovies()
    }
}

#if DEBUG
extension MovieListViewController {
    @objc func performLoadMovies() async {
        await loadMoviesForTest()
    }

    private func loadMoviesForTest() async {
        do {
            try await viewModel.loadMovies()
            tableView.reloadData()
        } catch {
            print("Mock load failed: \(error)")
        }
    }
}
#endif

class MockMovieService: MovieServiceProtocol {
    var fetchCalled = false
    var shouldFail = false
    var moviesToReturn: [Movie] = []

    func fetchMovies() async throws -> [Movie] {
        fetchCalled = true
        if shouldFail {
            throw NSError(domain: "TestError", code: 999, userInfo: nil)
        }
        return moviesToReturn
    }
}
