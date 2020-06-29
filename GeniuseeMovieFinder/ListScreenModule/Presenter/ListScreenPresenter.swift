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
    var searchController: UISearchController? { get set }
    func proceed()
}

protocol ListScreenPresenterProtocol: class {
    init(view: ListScreenProtocol)
    var listItems: ListItems? { get set }
    var searchResult: ListItems? { get set }
    func getCellData(for tableView: UITableView, indexPath: IndexPath) -> ListScreenTableViewCell
    func performSearch(from string: String)
    func itemsToDisplayAt(indexPath: IndexPath) -> Result?
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
            guard let listItems = listItems else { return }
            self.listItems = listItems
            print(listItems)
            self.view?.proceed()
        }
    }
    
    
    //MARK: - Public Methods
    
    
    public func getCellData(for tableView: UITableView, indexPath: IndexPath) -> ListScreenTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! ListScreenTableViewCell
        
        cell.tag = indexPath.row
        cell.posterImageView.image = nil
        guard let foundResults = itemsToDisplayAt(indexPath: indexPath) else { return ListScreenTableViewCell() }
        cell.movieNameLabel.text = foundResults.title
        if foundResults.overview?.isEmpty == false {
            cell.descriptionLabel.text = foundResults.overview
        } else {
            cell.descriptionLabel.text = "No overview found."
        }
        guard let posterPath = foundResults.posterPath else {
            cell.posterImageView.contentMode = .center
            cell.posterImageView.image = UIImage(named: "no-image")
            return cell
        }
        fetchCellImage(cell, posterPath, indexPath)
        return cell
    }

    public func performSearch(from string: String) {
        
        networkManager.performSearch(with: string) { (result) in
            guard let result = result else { return }
            self.searchResult = result
            print(result)
            self.view?.proceed()
        }
    }
    
    public func itemsToDisplayAt(indexPath: IndexPath) -> Result? {
        
        let item: Result?
        
        if (self.view?.searchController?.isActive)! && self.view?.searchController?.searchBar.text != "" {
            item = searchResult?.results?[indexPath.row]
        } else {
            item = listItems?.results?[indexPath.row]
        }
        return item
    }
    
    
    //MARK: - Private Methods
    
    private func fetchCellImage(_ cell: ListScreenTableViewCell, _ posterPath: String, _ indexPath: IndexPath) {
        
        cell.activityIndicator.isHidden = false
        cell.activityIndicator.startAnimating()
        networkManager.getPoster(posterPath: posterPath) { (image) in
            if cell.tag == indexPath.row {
                guard let image = image else { return }
                cell.posterImageView.contentMode = .scaleAspectFill
                cell.posterImageView.image = image
                cell.activityIndicator.isHidden = true
                cell.activityIndicator.stopAnimating()
            }
        }
    }
}

