//
//  ListScreenPresenter.swift
//  GeniuseeMovieFinder
//
//  Created by Victor Pelivan on 25.06.2020.
//  Copyright © 2020 Viktor Pelivan. All rights reserved.
//

import Foundation
import UIKit


//MARK: - Protocols

protocol ListScreenProtocol: class {
    func proceed()
}

protocol ListScreenPresenterProtocol: class {
    init(view: ListScreenProtocol)
    var listItems: ListItems? { get set }
    var searchResult: ListItems? { get set }
    func getCellData(for tableView: UITableView, indexPath: IndexPath) -> ListScreenTableViewCell
    func getGenresCastCrewData(indexPath: IndexPath, completion: @escaping (CastAndCrew?, Genres?) -> ())
}

class ListScreenPresenter: ListScreenPresenterProtocol {
    
    //MARK: - Variables
    weak var view: ListScreenProtocol?
    var listItems: ListItems?
    var searchResult: ListItems?

    
    //MARK: - External Dependencies
    let networkManager = NetworkManager()
    
    
    //MARK: - Interfaces
    required init(view: ListScreenProtocol) {
        
        self.view = view
        networkManager.getListItems { (listItems) in
            self.listItems = listItems
            print(listItems ?? "")
            self.view?.proceed()
        }
    }
    
    
    //MARK: - Public Methods
    public func getCellData(for tableView: UITableView, indexPath: IndexPath) -> ListScreenTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! ListScreenTableViewCell
        
        guard let foundResults = listItems?.results?[indexPath.row], let posterPath = foundResults.posterPath else { return ListScreenTableViewCell() }
        cell.movieNameLabel.text = foundResults.title
        cell.descriptionLabel.text = foundResults.overview
        cell.activityIndicator.isHidden = false
        cell.activityIndicator.startAnimating()
        networkManager.getPoster(posterPath: posterPath) { (image) in
            cell.activityIndicator.isHidden = true
            cell.activityIndicator.stopAnimating()
            cell.posterImageView.image = image
        }
        return cell
    }
    
    public func getGenresCastCrewData(indexPath: IndexPath, completion: @escaping (CastAndCrew?, Genres?) -> ()){
        
        let id = listItems?.results?[indexPath.row].id
        networkManager.getGenresCastCrew(for: id) { (castAndCrew, genres) in
            completion(castAndCrew, genres)
        }
    }
    
}

