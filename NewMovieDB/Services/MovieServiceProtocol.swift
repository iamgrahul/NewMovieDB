
/// A protocol defining the interface for a service that fetches movie data.
///
/// Conforming types are expected to implement asynchronous logic to retrieve a list of movies,
/// typically from a remote server or API.
protocol MovieServiceProtocol {

    /// Asynchronously fetches a list of movies.
    ///
    /// - Returns: An array of `Movie` objects retrieved from a data source.
    ///
    /// - Throws:
    ///   - `URLError` if the network request fails or the URL is invalid.
    ///   - A decoding error if the response data cannot be parsed into `Movie` objects.
    func fetchMovies() async throws -> [Movie]
}
