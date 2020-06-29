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
        
        guard let string = string else { return "No release date" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: string)
        formatter.dateFormat = "MMMM d, yyyy"
        guard let dateForSure = date else { return "No release date" }
        let formattedString = formatter.string(from: dateForSure)
        return formattedString
    }
    
    public func getDirectors(from crew: [Crew]?) -> String {
        
        guard let crew = crew else {return "No directors data"}
        var directors = ""
        
        for person in crew {
            if person.department == "Directing" {
                if person.job != nil {
                    directors.append(contentsOf: "\(person.name!) (\(person.job!)), ")
                } else {
                    directors.append(contentsOf: "\(person.name!), ")
                }
            }
        }
        directors = trimm(string: directors)
        return directors
    }
    
    public func getCast(from cast: [Cast]?) -> String {
        
        guard let cast = cast else {return "No directors data"}
        var castList = ""
        
        for person in cast {
            if person.character != "" && person.character != nil {
                castList.append(contentsOf: "\(person.name!) as \(person.character!), ")
            } else {
                castList.append(contentsOf: "\(person.name!), ")
            }
        }
        castList = trimm(string: castList)
        return castList
    }
    
    public func getGenres(from genres: [Genre]?) -> String {
        
        guard let genres = genres else {return "No directors data"}
        var genresList = ""
        
        for genre in genres {
            genresList.append(contentsOf: "\(genre.name!), ")
        }
        genresList = trimm(string: genresList)
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
