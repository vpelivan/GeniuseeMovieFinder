//
//  Genres.swift
//  GeniuseeMovieFinder
//
//  Created by Victor Pelivan on 26.06.2020.
//  Copyright © 2020 Viktor Pelivan. All rights reserved.
//

import Foundation

// MARK: - Genres
struct Genres: Codable {
    let genres: [Genre]?
}

// MARK: - Genre
struct Genre: Codable {
    let name: String?
}
