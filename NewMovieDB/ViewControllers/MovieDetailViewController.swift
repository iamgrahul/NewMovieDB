import UIKit

/// A view controller that displays the details of a selected movie.
class MovieDetailViewController: UIViewController {

    // MARK: - Properties

    /// The view model containing the movie data to be displayed.
    private(set) var viewModel: MovieDetailViewModel
    let label = UILabel()
    let imageview = UIImageView()
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

        // Setup image view
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.contentMode = .scaleAspectFit
        imageview.clipsToBounds = true

        // Setup label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = viewModel.movie.overview
        label.textAlignment = .center

        // Add subviews
        view.addSubview(imageview)
        view.addSubview(label)

        // Constraints
        NSLayoutConstraint.activate([
            imageview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageview.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageview.heightAnchor.constraint(equalToConstant: 200),
            imageview.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),

            label.topAnchor.constraint(equalTo: imageview.bottomAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        let imageURL = AppConstants.API.imageURL + viewModel.movie.posterPath
        Task {
            await imageview.setImage(from: imageURL)
        }
    }
}
