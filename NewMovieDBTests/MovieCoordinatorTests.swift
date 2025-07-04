//
//  MovieCoordinatorTests 2.swift
//  NewMovieDB
//
//  Created by Apple on 02/07/25.
//

import XCTest
@testable import NewMovieDB

final class MovieCoordinatorTests: XCTestCase {

    func testStart_PushesMovieListViewController() {
        let nav = UINavigationController()
        let coordinator = MovieCoordinator(navigationController: nav)

        coordinator.start()

        let rootVC = nav.viewControllers.first
        XCTAssertTrue(rootVC is MovieListViewController, "Expected MovieListViewController to be root")
    }

    func testShowMovieDetail_PushesMovieDetailViewController() {
        let nav = UINavigationController()
        let coordinator = MovieCoordinator(navigationController: nav)

        let movie = Movie(id: 1, title: "Test", overview: "Overview", releaseDate: "2024", posterPath: "")
        coordinator.showMovieDetail(movie: movie)

        let pushedVC = nav.viewControllers.last
        XCTAssertTrue(pushedVC is MovieDetailViewController, "Expected MovieDetailViewController to be pushed")
    }

    func testShowMovieDetail_PassesCorrectMovieToViewModel() {
        let nav = UINavigationController()
        let coordinator = MovieCoordinator(navigationController: nav)

        let movie = Movie(id: 10, title: "Expected", overview: "Description", releaseDate: "2025", posterPath: "")
        coordinator.showMovieDetail(movie: movie)

        let detailVC = nav.viewControllers.last as? MovieDetailViewController
        XCTAssertEqual(detailVC?.viewModel.movie.id, movie.id)
        XCTAssertEqual(detailVC?.viewModel.movie.title, "Expected")
    }
}
