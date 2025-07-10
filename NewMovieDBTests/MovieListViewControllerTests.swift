//
//  MovieListViewControllerTests.swift
//  MovieListViewControllerTests
//
//  Created by Apple on 19/06/25.
//

import XCTest
@testable import NewMovieDB

final class MovieListViewControllerTests: XCTestCase {

    private var sut: MovieListViewController!
    private var mockViewModel: MockMovieListViewModel!
    private var mockService: MockMovieService!

    // MARK: - Setup & Teardown

    override func setUp() {
        super.setUp()
        mockService = MockMovieService()
        mockViewModel = MockMovieListViewModel(service: mockService)
        sut = MovieListViewController(viewModel: mockViewModel)
    }

    override func tearDown() {
        sut = nil
        mockViewModel = nil
        mockService = nil
        super.tearDown()
    }

    // MARK: - Initialization

    func test_init_setsViewModelCorrectly() {
        XCTAssertTrue(sut.viewModel === mockViewModel)
    }

    // MARK: - View Lifecycle

    func test_viewDidLoad_configuresUIElements() {
        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.title, AppConstants.ViewControllerTitles.movieList)
        XCTAssertNotNil(sut.tableView.dataSource)
        XCTAssertNotNil(sut.tableView.delegate)
    }

    // MARK: - Successful Load

    func test_loadMovies_success_shouldReloadTableView() async {
        mockViewModel.moviesToReturn = [Movie.mock(title: "Titanic")]
        await sut.viewDidLoad()

        let expectation = XCTestExpectation(description: "Check row count on main thread")

        await MainActor.run {
            XCTAssertEqual(self.sut.tableView.numberOfRows(inSection: 0), 1)
            expectation.fulfill()
        }

        await fulfillment(of: [expectation], timeout: 1.0)
    }


    // MARK: - TableView DataSource

    func test_tableView_numberOfRows_matchesMovieCount() {
        mockViewModel.moviesToReturn = [Movie.mock(), Movie.mock()]
        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.tableView(sut.tableView, numberOfRowsInSection: 0), 2)
    }

    func test_tableView_cellForRow_setsCorrectTitle() {
        mockViewModel.moviesToReturn = [Movie.mock(title: "Interstellar")]
        sut.loadViewIfNeeded()

        let cell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(cell.textLabel?.text, "Interstellar")
    }

    func test_tableView_cellForRow_withInvalidIndex_shouldShowFallbackText() {
        mockViewModel.moviesToReturn = []
        sut.loadViewIfNeeded()

        let cell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(cell.textLabel?.text, AppConstants.Messages.invalidMovie)
    }

    // MARK: - Movie Access Tests

    func test_movieAt_validIndex_shouldReturnMovie() throws {
        let movie = Movie.mock(title: "Gladiator")
        mockViewModel.moviesToReturn = [movie]
        sut.loadViewIfNeeded()

        let result = try mockViewModel.movie(at: 0)
        XCTAssertEqual(result.title, "Gladiator")
    }

    func test_movieAt_negativeIndex_shouldThrow() {
        mockViewModel.moviesToReturn = [Movie.mock()]
        sut.loadViewIfNeeded()

        XCTAssertThrowsError(try mockViewModel.movie(at: -1)) { error in
            XCTAssertEqual(error as? MockError, .invalidIndex)
        }
    }

    func test_movieAt_outOfBoundsIndex_shouldThrow() {
        mockViewModel.moviesToReturn = [Movie.mock()]
        sut.loadViewIfNeeded()

        XCTAssertThrowsError(try mockViewModel.movie(at: 5)) { error in
            XCTAssertEqual(error as? MockError, .invalidIndex)
        }
    }

    // MARK: - Selection

    func test_didSelectRow_shouldCallViewModelDidSelect() {
        let movie = Movie.mock(title: "Inception")
        mockViewModel.moviesToReturn = [movie]
        sut.loadViewIfNeeded()

        sut.tableView(sut.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))

        XCTAssertEqual(mockViewModel.selectedMovie, movie)
    }

    func test_didSelectRow_invalidIndex_shouldNotCrash() {
        mockViewModel.moviesToReturn = []
        sut.loadViewIfNeeded()

        sut.tableView(sut.tableView, didSelectRowAt: IndexPath(row: 5, section: 0))

        XCTAssertNil(mockViewModel.selectedMovie)
    }
}

// MARK: - Supporting Mocks

final class MockMovieService: MovieServiceProtocol {
    var shouldFail = false
    var moviesToReturn: [Movie] = []

    func fetchMovies() async throws -> [Movie] {
        if shouldFail {
            throw MockError.testError
        }
        return moviesToReturn
    }
}

final class MockMovieListViewModel: MovieListViewModel {
    var moviesToReturn: [Movie] = []
    var shouldFail = false
    var loadMoviesCallCount = 0
    var selectedMovie: Movie?
    override var movies: [Movie] {
        get { return moviesToReturn }
        set { moviesToReturn = newValue }
    }

    override func loadMovies() async throws {
        loadMoviesCallCount += 1
        if shouldFail {
            throw MockError.testError
        } else {
            self.movies = moviesToReturn
        }
    }

    override func movie(at index: Int) throws -> Movie {
        guard index >= 0 && index < moviesToReturn.count else {
            throw MockError.invalidIndex
        }
        return moviesToReturn[index]
    }

    override func didSelect(movie: Movie) {
        selectedMovie = movie
    }
}

enum MockError: Error {
    case testError
    case invalidIndex
}

extension Movie {
    static func mock(id: Int = 1, title: String = "Test Movie") -> Movie {
        return Movie(id: id, title: title, overview: "Overview", releaseDate: "2023-01-01", posterPath: "/test.jpg")
    }
}
