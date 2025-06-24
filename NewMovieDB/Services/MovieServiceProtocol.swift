protocol MovieServiceProtocol {
    func fetchMovies() async throws -> [Movie]
}
