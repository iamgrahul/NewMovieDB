import UIKit

/// A view controller that displays a list of movies in a table view.
class MovieListViewController: UIViewController {

    // MARK: - Properties

    /// The view model that provides data and handles user interactions.
    private(set) var viewModel: MovieListViewModel
    private var activityIndicator = UIActivityIndicatorView(style: .large)
    private var pullControl = UIRefreshControl()

    /// The table view used to display the list of movies.
    let tableView = UITableView()

    // MARK: - Initializers

    /// Initializes the view controller with the given view model.
    ///
    /// - Parameter viewModel: The view model providing movie data.
    init(viewModel: MovieListViewModel) {
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

    /// Called after the view has been loaded into memory. Sets up the view and loads movies.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadMovies()
    }

    /// Loads movie data from the view model asynchronously and reloads the table view.
    func loadMovies() {
        if NetworkManager.shared.isConnectedToInternet {
            activityIndicator.startAnimating()
            Task {
                do {
                    // Background work
                    try await viewModel.loadMovies()

                    // UI updates on main thread
                    await MainActor.run {
                        tableView.reloadData()
                        activityIndicator.stopAnimating()
                    }
                } catch {
                    await MainActor.run {
                        activityIndicator.stopAnimating()
                        showErrorAlert(error: error)
                    }
                }
            }
        } else {
            showErrorAlert(error: AppErrors.noInternet, errorTitle: AppConstants.Messages.noInternetConnection)
        }
    }

    /// Displays an alert with the error message and a Retry button.
    func showErrorAlert(error: Error,
                        errorTitle: String? = AppConstants.Messages.failedMessage) {
        let alert = UIAlertController(
            title: errorTitle,
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: AppConstants.Messages.retry, style: .default, handler: { [weak self] _ in
            self?.loadMovies()
        }))
        alert.addAction(UIAlertAction(title: AppConstants.Messages.cancel, style: .cancel, handler: nil))
        present(alert, animated: false)
    }
}

// MARK: - Private Helpers

private extension MovieListViewController {

    /// Configures the view's appearance and sets up the table view.
    func setupView() {
        title = AppConstants.ViewControllerTitles.movieList
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: AppConstants.CellIdentifiers.movieCell)
        setupActivityIndicator()
        setupPullToRefresh()
    }

    /// setup for Activity Indicator
    func setupActivityIndicator() {
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
    }

    /// setup for Pull To Refresh
    func setupPullToRefresh() {
        pullControl.attributedTitle = NSAttributedString(string: AppConstants.Messages.pullToRefresh)
        pullControl.addTarget(self, action: #selector(refreshListData(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = pullControl
        } else {
            tableView.addSubview(pullControl)
        }
    }

    /// Actions for pull to refresh
    @objc private func refreshListData(_ sender: Any) {
        self.pullControl.endRefreshing() // You can stop after API Call
        // Call API
        loadMovies()
    }
}

// MARK: - UITableViewDataSource

extension MovieListViewController: UITableViewDataSource {

    /// Returns the number of rows in the given section.
    ///
    /// - Parameters:
    ///   - tableView: The table view requesting this information.
    ///   - section: The index number of the section.
    /// - Returns: The number of rows (movies) in the section.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }

    /// Configures and returns a cell to display for the given row.
    ///
    /// - Parameters:
    ///   - tableView: The table view requesting the cell.
    ///   - indexPath: The index path of the cell.
    /// - Returns: A configured `UITableViewCell` instance.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.CellIdentifiers.movieCell, for: indexPath)
        do {
            let movie = try viewModel.movie(at: indexPath.row)
            cell.textLabel?.text = movie.title
        } catch {
            cell.textLabel?.text = AppConstants.Messages.invalidMovie
            // Optionally log error or report
            print("Failed to load movie at index \(indexPath.row): \(error)")
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MovieListViewController: UITableViewDelegate {

    /// Called when a movie row is selected. Passes the selected movie to the view model.
    ///
    /// - Parameters:
    ///   - tableView: The table view informing about the selection.
    ///   - indexPath: The index path of the selected row.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            let movie = try viewModel.movie(at: indexPath.row)
            viewModel.didSelect(movie: movie)
        } catch {
            // Optionally log or present an error if needed
            print("Failed to select movie at index \(indexPath.row): \(error)")
        }
    }
}
