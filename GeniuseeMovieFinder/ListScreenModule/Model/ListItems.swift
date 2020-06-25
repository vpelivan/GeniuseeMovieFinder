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
    let page, totalPages, totalResults: Int?
    let results: [Result]?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct Result: Codable {
    let title, overview, posterPath, releaseDate, originalTitle, backdropPath, originalName, name, firstAirDate: String?
    let id, voteCount: Int?
    let video, adult: Bool?
    let voteAverage, popularity: Double?
    let originalLanguage: OriginalLanguage?
    let genreIDS: [Int]?
    let mediaType: MediaType?
    let originCountry: [String]?

    enum CodingKeys: String, CodingKey {
        case id, video, title, name, popularity, adult, overview
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case genreIDS = "genre_ids"
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case originalName = "original_name"
        case firstAirDate = "first_air_date"
        case originCountry = "origin_country"
    }
}

enum MediaType: String, Codable {
    case movie = "movie"
    case tv = "tv"
}

enum OriginalLanguage: String, Codable {
    case de = "de"
    case en = "en"
    case fr = "fr"
    case pl = "pl"
}
