/// A container for application-wide static constants used throughout the app.
struct AppConstants {

    // MARK: - API

    /// API-related constants including base URLs and endpoints.
    enum API {
        /// The base URL for all network requests.
        static let baseURL = "https://amairasolutions.com"

        /// The endpoint URL for fetching movies.
        static let moviesEndpoint = "\(baseURL)/test.json"
    }

    // MARK: - ViewControllerTitles

    /// Constants used for view controller titles.
    enum ViewControllerTitles {
        /// The title for the movie list screen.
        static let movieList = "Movies"
    }

    // MARK: - Messages

    /// Constants used for displaying messages.
    enum Messages {
        static let retry = "Retry"
        static let cancel = "Cancel"
        static let failedMessage = "Failed to Load Movies"
        static let invalidMovie = "Invalid movie"
    }

    // MARK: - CellIdentifiers

    /// Constants used as identifiers for reusable table or collection view cells.
    enum CellIdentifiers {
        /// The reuse identifier for the movie list cell.
        static let movieCell = "Cell"
    }
}
