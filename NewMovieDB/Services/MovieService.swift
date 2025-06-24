import Foundation

class MovieService: MovieServiceProtocol {
    func fetchMovies() async throws -> [Movie] {
        guard let url = URL(string: "https://amairasolutions.com/test.json") else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let movies = try JSONDecoder().decode(MovieData.self, from: data)
        return movies.results
    }
}
