//
//  CastAndCrew.swift
//  GeniuseeMovieFinder
//
//  Created by Victor Pelivan on 25.06.2020.
//  Copyright © 2020 Viktor Pelivan. All rights reserved.
//

import Foundation

// MARK: - CastAndCrew
struct CastAndCrew: Codable {
    let cast: [Cast]?
    let crew: [Crew]?
}

// MARK: - Cast
struct Cast: Codable {
    let character, name: String?
}

// MARK: - Crew
struct Crew: Codable {
    let department, job, name: String?
}

