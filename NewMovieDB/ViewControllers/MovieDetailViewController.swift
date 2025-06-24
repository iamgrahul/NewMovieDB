import UIKit

class MovieDetailViewController: UIViewController {
    private(set) var viewModel: MovieDetailViewModel

    init(viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupview()
    }
}

private extension MovieDetailViewController {
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
