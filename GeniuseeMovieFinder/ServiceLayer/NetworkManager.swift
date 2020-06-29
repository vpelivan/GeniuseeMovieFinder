//
//  NetworkManager.swift
//  GeniuseeMovieFinder
//
//  Created by Victor Pelivan on 25.06.2020.
//  Copyright © 2020 Viktor Pelivan. All rights reserved.
//

import Foundation
import UIKit

class NetworkManager {
    
    //MARK: - Variables
    
    private let apiUrl = "https://api.themoviedb.org/3/"
    private let apiKey = "0a266d3bee8651753234b627f7bd0261"
    private let apiKeyParam = "?api_key="

    
    //MARK: - External Dependencies
    
    let networkService = NetworkService()
    
    
    //MARK: - Public Methods
    
    public func getListItems(filters: String = "", completion: @escaping (ListItems?) -> ()) {
        
        let urlString = "trending/movie/week"
        guard let baseUrl = URL(string: apiUrl + urlString + apiKeyParam + apiKey + filters) else {
            completion(nil)
            return
        }
        getData(into: ListItems.self, from: baseUrl) { result in
            completion(result)
        }
    }
    
    public func getPoster(width: Int = 200, posterPath: String, completion: @escaping (UIImage?) -> ()) {
        
        let urlString = "https://image.tmdb.org/t/p/w\(width)"
        guard let baseUrl = URL(string: urlString + posterPath) else {
            completion(nil)
            return
        }
        networkService.getImage(from: baseUrl) { (image) in
            guard let image = image else {
                completion(nil)
                return
            }
            completion(image)
        }
    }
    
    public func getGenresCastCrew(for id: Int?, completion: @escaping (CastAndCrew?, Genres?) -> ()) {

        guard let id = id else {
            completion(nil, nil)
            return
        }
        let genresUrlString = "movie/\(id)"
        let castAndCrewUrlString = "movie/\(id)/credits"
        
        getDetailsScreenData(urlString: genresUrlString, type: Genres.self) { (genres) in
            self.getDetailsScreenData(urlString: castAndCrewUrlString, type: CastAndCrew.self) { (castAndCrew) in
                completion(castAndCrew, genres)
            }
        }
    }
    
    public func performSearch(filters: String = "", with name: String?, completion: @escaping (ListItems?) -> ()) {
        guard let name = name?.replacingOccurrences(of: " ", with: "%20").trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        let urlString = "search/movie?query=\(name)"
        guard let baseUrl = URL(string: apiUrl + urlString + "&api_key=" + apiKey + filters) else {
            completion(nil)
            return
        }
        getData(into: ListItems.self, from: baseUrl) { (result) in
            completion(result)
        }
    }
    
    
    //MARK: - Private Methods
    
    private func getDetailsScreenData<T: Decodable>(urlString: String, type: T.Type, completion: @escaping (T?) -> ()) {
        
        guard let baseUrl = URL(string: apiUrl + urlString + apiKeyParam + apiKey) else {
            completion(nil)
            return
        }
        getData(into: T.self, from: baseUrl) { (result) in
            completion(result)
        }
    }
    
    private func getData<T: Decodable>(into: T.Type, from baseUrl: URL, completion: @escaping (T?) -> ()) {
        networkService.getData(into: T.self, from: baseUrl) { result in
            guard let result = result else {
                completion(nil)
                return
            }
            completion(result)
        }
    }
    
}
