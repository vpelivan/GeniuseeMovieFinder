//
//  ListScreenModel.swift
//  GeniuseeMovieFinder
//
//  Created by Victor Pelivan on 25.06.2020.
//  Copyright © 2020 Viktor Pelivan. All rights reserved.
//

import Foundation


// MARK: - ListItems

struct ListItems: Codable {
    var page, totalPages, totalResults: Int?
    var results: [Result]?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}


// MARK: - Result

struct Result: Codable {
    let title, overview, posterPath, releaseDate: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
    }
}

