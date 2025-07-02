//
//  AppConstants.swift
//  NewMovieDB
//
//  Created by Apple on 02/07/25.
//

struct AppConstants {
    enum API {
        static let baseURL = "https://amairasolutions.com"
        static let moviesEndpoint = "\(baseURL)/test.json"
    }

    enum ViewControllerTitles {
        static let movieList = "Movies"
    }

    enum CellIdentifiers {
        static let movieCell = "Cell"
    }
}
