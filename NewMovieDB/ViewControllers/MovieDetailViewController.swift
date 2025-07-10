import UIKit

/// A view controller that displays the details of a selected movie.
class MovieDetailViewController: UIViewController {
    
    // MARK: - Properties

    /// The view model containing the movie data to be displayed.
    private(set) var viewModel: MovieDetailViewModel

    // MARK: - Initializers

    /// Initializes the view controller with a given view model.
    ///
    /// - Parameter viewModel: The view model providing the movie details.
    init(viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    /// Required initializer for decoding from storyboard or nib (not implemented).
    ///
    /// - Parameter coder: An unarchiver object.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    /// Called after the view has been loaded. Triggers view setup.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupview()
    }
}

// MARK: - Private Helpers

private extension MovieDetailViewController {

    /// Configures the view with movie details from the view model.
    ///
    /// Sets background color, title, and creates a label for the movie overview.
    func setupview() {
        view.backgroundColor = .white
        title = viewModel.movie.title

        let label = UILabel()
        label.numberOfLines = 0
        label.text = viewModel.movie.overview
        label.frame = view.bounds.insetBy(dx: 16, dy: 16)
        view.addSubview(label)
    }
}
