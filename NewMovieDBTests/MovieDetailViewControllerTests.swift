

import XCTest
@testable import NewMovieDB

final class MovieDetailViewControllerTests: XCTestCase {
    var sut: MovieDetailViewController!
    var viewModel: MovieDetailViewModel!
    var mockMovie = Movie.mock()

    override func setUp() {
        viewModel = MovieDetailViewModel(movie: mockMovie)
        sut = MovieDetailViewController(viewModel: viewModel)
        sut.viewDidLoad()
    }

    func testViewController_InitializesWithViewModel() {
        XCTAssertEqual(sut.viewModel.movie.title, mockMovie.title)
    }
}
