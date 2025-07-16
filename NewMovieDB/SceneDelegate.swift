//
//  SceneDelegate.swift
//  NewMovieDB
//
//  Created by Apple on 19/06/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: MovieCoordinator?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        setupFirstScreen(scene)
    }

    func setupFirstScreen(_ scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        coordinator = MovieCoordinator()
        let navigationController = coordinator?.start()

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
}
