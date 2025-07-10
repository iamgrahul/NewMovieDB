
/// A model representing a single movie item, typically returned from a movie API.
///
/// Conforms to `Decodable` to support JSON parsing and `Equatable` for comparisons.
struct Movie: Decodable, Equatable {

    /// Unique identifier for the movie.
    let id: Int

    /// The title of the movie.
    let title: String

    /// A brief summary or description of the movie.
    let overview: String

    /// The release date of the movie in `"yyyy-MM-dd"` format.
    let releaseDate: String

    /// The relative path to the movie's poster image.
    let posterPath: String

    /// Maps JSON keys from the API response to the corresponding Swift property names.
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case releaseDate = "release_date"
        case posterPath = "poster_path"
    }
}

/// A model representing a response object that contains a list of movies.
struct MovieData: Decodable {

    /// An array of `Movie` objects returned by the API.
    let results: [Movie]
}
