import XCTest
@testable import NewMovieDB

class MovieCoordinatorTests: XCTestCase {
    var coordinator: MovieCoordinator!
    override func setUp() {
        super.setUp()
        coordinator = MovieCoordinator()
    }

    override func tearDown() {
        coordinator = nil
        super.tearDown()
    }

    /// test to check start method returns a object of UINavigationController
    func testStartReturnsNavigationController() {
        let navController = coordinator.start()
        XCTAssertTrue(navController is UINavigationController)
    }

    /// test to check that the rootviewcontroller is object of MovieListViewController
    func testStartSetsMovieListVCAsRoot() {
        let navController = coordinator.start()
        let rootVC = navController.viewControllers.first
        XCTAssertTrue(rootVC is MovieListViewController)
    }

    /// check viewmodel shouldnot be nil and viewmodel's coordinator should have the same coordinator.
    func testStartSetsViewModelWithCoordinator() {
        let navController = coordinator.start()
        let rootVC = navController.viewControllers.first as? MovieListViewController
        XCTAssertNotNil(rootVC?.viewModel)
        XCTAssertTrue(rootVC?.viewModel.coordinator === coordinator)
    }

    /// should have MovieDetailViewController at the top navigation stack when pushed.
    func testShowMovieDetailPushesDetailViewController() {
        coordinator.navigationController = UINavigationController()

        coordinator.showMovieDetail(movie: Movie.mock())

        let pushedVC = coordinator.navigationController.topViewController
        XCTAssertTrue(pushedVC is MovieDetailViewController)
    }

    /// should show correct correct movie on details screen.
    func testShowMovieDetailPassesCorrectMovie() {
        coordinator.navigationController = UINavigationController()

        let mockMovie = Movie.mock()
        coordinator.showMovieDetail(movie: mockMovie)

        let detailVC = coordinator.navigationController.topViewController as? MovieDetailViewController
        XCTAssertEqual(detailVC?.viewModel.movie.id, mockMovie.id)
        XCTAssertEqual(detailVC?.viewModel.movie.title, mockMovie.title)
    }
}
