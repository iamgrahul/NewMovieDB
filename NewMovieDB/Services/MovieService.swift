import Foundation

/// A concrete implementation of `MovieServiceProtocol` responsible for fetching movie data from a remote API.
class MovieService: MovieServiceProtocol {

    /// Asynchronously fetches a list of movies from the configured API endpoint.
    ///
    /// This method performs a network call to the `moviesEndpoint` URL specified in `AppConstants.API`.
    /// It decodes the response into an array of `Movie` objects.
    ///
    /// - Returns: An array of `Movie` objects retrieved from the remote API.
    ///
    /// - Throws:
    ///   - `URLError.badURL` if the URL is invalid.
    ///   - An error thrown by `URLSession` if the network request fails.
    ///   - A decoding error if the response cannot be parsed into `MovieData`.
    func fetchMovies() async throws -> [Movie] {
        guard let url = URL(string: AppConstants.API.moviesEndpoint) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let movies = try JSONDecoder().decode(MovieData.self, from: data)
        return movies.results
    }
}
