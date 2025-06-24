class MovieListViewModel {
    private let service: MovieServiceProtocol
    private(set) var movies: [Movie] = []

    init(service: MovieServiceProtocol) {
        self.service = service
    }

    func loadMovies() async throws {
        self.movies = try await service.fetchMovies()
    }

    func movie(at index: Int) -> Movie {
        return movies[index]
    }
}
