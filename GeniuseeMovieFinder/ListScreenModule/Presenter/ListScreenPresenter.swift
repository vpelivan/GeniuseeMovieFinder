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
    var currentSearchString: String? { get set }
    func getCellData(for tableView: UITableView, indexPath: IndexPath) -> ListScreenTableViewCell
    func performSearch(from string: String)
    func itemsToDisplayAt(indexPath: IndexPath) -> Result?
    func performPagination(for indexPath: IndexPath)
}

class ListScreenPresenter: ListScreenPresenterProtocol {
    
    //MARK: - Variables
    
    weak var view: ListScreenProtocol?
    var listItems: ListItems?
    var searchResult: ListItems?
    var currentSearchString: String?

    
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
        
        currentSearchString = string
        networkManager.performSearch(with: string) { (result) in
            guard let result = result else { return }
            self.searchResult = result
            print(result)
            self.view?.proceed()
        }
    }
    
    public func performPagination(for indexPath: IndexPath) {
        
        if isSearchSource() == true {
            performSearchResultPagination(for: indexPath)
        } else {
            performListItemsPagination(for: indexPath)
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
    
    private func performSearchResultPagination(for indexPath: IndexPath) {

        guard let totalCount = searchResult?.results?.count else { return }
        if indexPath.row == totalCount - 1 {
            guard let page = searchResult?.page, let totalPages = searchResult?.totalPages else { return }
            let nextPage = page + 1
            guard nextPage <= totalPages else { return }
            networkManager.performSearch(filters: "&page=\(nextPage)", with: currentSearchString) { (searchResult) in
                guard let searchResult = searchResult else { return }
                self.searchResult?.results! += searchResult.results!
                self.searchResult?.page! += 1
                self.view?.proceed()
            }
        }
    }

    private func performListItemsPagination(for indexPath: IndexPath) {
        guard let totalCount = listItems?.results?.count else { return }
        if indexPath.row == totalCount - 1 {
            guard let page = listItems?.page, let totalPages = listItems?.totalPages else { return }
            let nextPage = page + 1
            guard nextPage <= totalPages else { return }
            networkManager.getListItems(filters: "&page=\(nextPage)") { (listItems) in
                guard let listItems = listItems else { return }
                self.listItems?.results! += listItems.results!
                self.listItems?.page! += 1
                self.view?.proceed()
            }
        }
    }
    
    private func isSearchSource() -> Bool {
        if (self.view?.searchController?.isActive)! && self.view?.searchController?.searchBar.text != "" {
            return true
        } else {
            return false
        }
    }
    
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

