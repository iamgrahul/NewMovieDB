/// A view model that provides data for the movie detail screen.
class MovieDetailViewModel {

    // MARK: - Properties

    /// The movie object containing details to be displayed.
    let movie: Movie

    // MARK: - Initializers

    /// Initializes the view model with a given movie.
    ///
    /// - Parameter movie: The `Movie` instance whose details will be exposed to the view.
    init(movie: Movie) {
        self.movie = movie
    }
}
