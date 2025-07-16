/// A view model responsible for managing and providing movie data to the movie list screen.
class MovieListViewModel {

    // MARK: - Properties

    /// A weak reference to the coordinator for handling navigation events.
    weak var coordinator: MovieCoordinator?

    /// The service used to fetch movie data.
    private let service: MovieServiceProtocol

    /// The list of movies fetched from the API.
    private(set) var movies: [Movie] = []

    // MARK: - Initializers

    /// Initializes the view model with the provided movie service.
    ///
    /// - Parameter service: A type conforming to `MovieServiceProtocol` for fetching movies.
    init(service: MovieServiceProtocol) {
        self.service = service
    }

    // MARK: - Data Loading

    /// Asynchronously loads movies using the service and updates the local list.
    ///
    /// - Throws: An error if the service fails to fetch or decode movies.
    func loadMovies() async throws {
        self.movies = try await service.fetchMovies()
    }

    // MARK: - Data Access

    /// Returns the movie at a specific index in the list.
    ///
    /// - Parameter index: The index of the movie in the array.
    /// - Returns: A `Movie` object at the given index.
    /// - Throws: `AppErrors.invalidIndex` if index is out of bounds.
    func movie(at index: Int) throws -> Movie {
        guard index >= 0 && index < movies.count else {
            throw AppErrors.invalidIndex
        }
        return movies[index]
    }

    // MARK: - User Interaction

    /// Handles selection of a movie and triggers navigation via the coordinator.
    ///
    /// - Parameter movie: The selected `Movie` to show in detail.
    func didSelect(movie: Movie) {
        coordinator?.showMovieDetail(movie: movie)
    }
}
