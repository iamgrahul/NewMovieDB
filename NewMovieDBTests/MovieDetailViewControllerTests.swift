

import XCTest
@testable import NewMovieDB

final class MovieDetailViewControllerTests: XCTestCase {
    var sut: MovieDetailViewController!
    var viewModel: MovieDetailViewModel!
    let mockMovie = Movie(id: 1003, title: "title", overview: "Overview", releaseDate: "2023-01-01", posterPath: "/test.jpg")

    override func setUp() {
        viewModel = MovieDetailViewModel(movie: mockMovie)
        sut = MovieDetailViewController(viewModel: viewModel)
        sut.viewDidLoad()
    }

    func testViewController_InitializesWithViewModel() {
        XCTAssertEqual(sut.viewModel.movie.title, mockMovie.title)
    }
}
