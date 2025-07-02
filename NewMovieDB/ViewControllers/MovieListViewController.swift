//
//  MovieListViewController.swift
//  NewMovieDB
//
//  Created by Apple on 19/06/25.
//

import UIKit

class MovieListViewController: UIViewController {
    private(set) var viewModel: MovieListViewModel
    let tableView = UITableView()

    init(viewModel: MovieListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadMovies()
    }
}

private extension MovieListViewController {
    func setupView() {
        title = "Movies"
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    func loadMovies() {
        Task {
            do {
                try await viewModel.loadMovies()
                tableView.reloadData()
            } catch {
                print("Error loading movies: \(error)")
            }
        }
    }
}

extension MovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let movie = viewModel.movie(at: indexPath.row)
        cell.textLabel?.text = movie.title
        return cell
    }
}

extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = viewModel.movie(at: indexPath.row)
        viewModel.didSelect(movie: movie)
    }
}
