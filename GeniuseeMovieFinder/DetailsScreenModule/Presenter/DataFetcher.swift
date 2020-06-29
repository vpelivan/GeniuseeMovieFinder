//
//  DataFetcher.swift
//  GeniuseeMovieFinder
//
//  Created by Victor Pelivan on 26.06.2020.
//  Copyright © 2020 Viktor Pelivan. All rights reserved.
//

import Foundation

class DataFetcher {
    
    //MARK: - Public Methods
    
    public func getDate(from string: String?) -> String {
        
        guard let string = string else { return "Release date not found." }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: string)
        formatter.dateFormat = "MMMM d, yyyy"
        guard let dateForSure = date else { return "Release date not found." }
        let formattedString = formatter.string(from: dateForSure)
        return formattedString
    }
    
    public func getDirectors(from crew: [Crew]?) -> String {
        
        guard let crew = crew else { return "Directors not found." }
        var directors = ""
        
        for person in crew {
            if person.department == "Directing" {
                if person.job != nil && person.job != "" && person.name != nil {
                    directors.append(contentsOf: "\(person.name!) (\(person.job!)), ")
                } else {
                    directors.append(contentsOf: "\(person.name!), ")
                }
            }
        }
        directors = trimm(string: directors)
        if directors == "" {
            directors.append(contentsOf: "Directors not found.")
        }
        return directors
    }
    
    public func getCast(from cast: [Cast]?) -> String {
        
        guard let cast = cast else { return "Cast list not found." }
        var castList = ""
        
        for person in cast {
            if person.character != "" && person.character != nil {
                castList.append(contentsOf: "\(person.name!) as \(person.character!), ")
            } else {
                castList.append(contentsOf: "\(person.name!), ")
            }
        }
        castList = trimm(string: castList)
        if castList == "" {
            castList.append(contentsOf: "Cast list not found.")
        }
        return castList
    }
    
    public func getGenres(from genres: [Genre]?) -> String {
        
        guard let genres = genres else {return "Genres not found."}
        var genresList = ""
        
        for genre in genres {
            if genre.name != "" && genre.name != nil {
                genresList.append(contentsOf: "\(genre.name!), ")
            }
        }
        genresList = trimm(string: genresList)
        if genresList == "" {
            genresList.append(contentsOf: "Genres not found.")
        }
        return genresList
    }
    
    
    //MARK: - Private Methods
    
    private func trimm(string: String) -> String {
        
        var string = string
        
        string = string.trimmingCharacters(in: .whitespacesAndNewlines)
        string = string.trimmingCharacters(in: .init(arrayLiteral: ","))
        return string
    }
}
