//
//  MovieCoordinator.swift
//  NewMovieDB
//
//  Created by Apple on 02/07/25.
//
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
    func showMovieDetail(movie: Movie)
}

class MovieCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let service = MovieService()
        let viewModel = MovieListViewModel(service: service)
        viewModel.coordinator = self
        let vc = MovieListViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: false)
    }

    func showMovieDetail(movie: Movie) {
        let detailVM = MovieDetailViewModel(movie: movie)
        let detailVC = MovieDetailViewController(viewModel: detailVM)
        navigationController.pushViewController(detailVC, animated: true)
    }
}
