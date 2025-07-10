
import UIKit

/// A protocol that defines the responsibilities of a coordinator, which manages navigation and flow between view controllers.
protocol Coordinator {
    /// The navigation controller used to manage the navigation stack.
    var navigationController: UINavigationController { get }

    /// Starts the coordinator and returns the root navigation controller.
    ///
    /// - Returns: A configured `UINavigationController` instance with the initial screen.
    func start() -> UINavigationController

    /// Navigates to the movie detail screen for a specific movie.
    ///
    /// - Parameter movie: A `Movie` object representing the movie to display in detail.
    func showMovieDetail(movie: Movie)
}

/// A concrete implementation of the `Coordinator` protocol that manages navigation for the Movie module.
class MovieCoordinator: Coordinator {
    
    /// The navigation controller used for presenting and managing view controllers.
    var navigationController: UINavigationController

    /// Initializes a new instance of `MovieCoordinator` with an empty `UINavigationController`.
    init () {
        self.navigationController = UINavigationController()
    }

    /// Starts the movie flow by initializing the movie list view and setting it as the root view controller.
    ///
    /// - Returns: A `UINavigationController` with the `MovieListViewController` as the root.
    func start() -> UINavigationController {
        let service = MovieService()
        let viewModel = MovieListViewModel(service: service)
        viewModel.coordinator = self
        let vc = MovieListViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: false)
        return navigationController
    }

    /// Navigates to the movie detail screen by pushing `MovieDetailViewController` onto the navigation stack.
    ///
    /// - Parameter movie: The `Movie` object whose details will be shown.
    func showMovieDetail(movie: Movie) {
        let detailVM = MovieDetailViewModel(movie: movie)
        let detailVC = MovieDetailViewController(viewModel: detailVM)
        navigationController.pushViewController(detailVC, animated: true)
    }
}
