//
//  MovieDetailViewController.swift
//  NewMovieDB
//
//  Created by Apple on 23/06/25.
//

import XCTest
@testable import NewMovieDB

final class MovieDetailViewControllerTests: XCTestCase {
    var sut: MovieDetailViewController!
    var viewModel: MovieDetailViewModel!
    var mockMovie: Movie!

    override func setUp() {
        mockMovie = Movie(id: 1,
                          title: "Movie Test",
                          overview: "Overview",
                          releaseDate: "2023",
                          posterPath: "")
        viewModel = MovieDetailViewModel(movie: mockMovie)
        sut = MovieDetailViewController(viewModel: viewModel)
        sut.viewDidLoad()
    }

    func testViewController_InitializesWithViewModel() {
        XCTAssertEqual(sut.viewModel.movie.title, mockMovie.title)
    }
}
