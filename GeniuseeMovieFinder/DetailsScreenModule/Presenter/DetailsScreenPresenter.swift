//
//  DetailsScreenPresenter.swift
//  GeniuseeMovieFinder
//
//  Created by Victor Pelivan on 25.06.2020.
//  Copyright © 2020 Viktor Pelivan. All rights reserved.
//

import Foundation
import UIKit


//MARK: - Protocols

protocol DetailsScreenProtocol: class {
    func proceed()
}

protocol DetailsScreenPresenterProtocol: class {
    init(view: DetailsScreenProtocol, listItem: Result?)
    var listItem: Result? { get set }
    var genres: Genres? { get set }
    var castAndCrew: CastAndCrew? { get set }
    func getPosterCellData(for tableView: UITableView, indexPath: IndexPath) -> PosterTableViewCell
    func getTextCellData(for tableView: UITableView, indexPath: IndexPath) -> TextTableViewCell
}

class DetailsScreenPresenter: DetailsScreenPresenterProtocol {
    
    
    //MARK: - Variables
    
    weak var view: DetailsScreenProtocol?
    var listItem: Result?
    var genres: Genres?
    var castAndCrew: CastAndCrew?

    
    //MARK: - External Dependencies
    
    let networkManager = NetworkManager()
    let dataFetcher = DataFetcher()
    
    
    //MARK: - Interfaces
    
    required init(view: DetailsScreenProtocol, listItem: Result?) {
        
        self.view = view
        self.listItem = listItem
        guard let id = listItem?.id else { return }
        networkManager.getGenresCastCrew(for: id) { (castAndCrew, genres) in
            guard let castAndCrew = castAndCrew, let genres = genres else { return }
            self.castAndCrew = castAndCrew
            self.genres = genres
            self.view?.proceed()
        }
        
    }
    
    
    //MARK: - Public Methods
    
    public func getPosterCellData(for tableView: UITableView, indexPath: IndexPath) -> PosterTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PosterCell", for: indexPath) as! PosterTableViewCell
        guard let posterPath = listItem?.posterPath else {
            cell.posterImageView.contentMode = .center
            cell.posterImageView.image = UIImage(named: "no-image")
            return cell
        }
        cell.activityIndicator.isHidden = false
        cell.activityIndicator.startAnimating()
        networkManager.getPoster(width: 500, posterPath: posterPath) { (image) in
            guard let image = image else { return }
            cell.activityIndicator.isHidden = true
            cell.activityIndicator.stopAnimating()
            cell.posterImageView.image = image
        }
        return cell
    }
    
    
    
    public func getTextCellData(for tableView: UITableView, indexPath: IndexPath) -> TextTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextTableViewCell
        
        switch indexPath.row {
        case 1:
            cell.titleLabel.text = "Description:"
            cell.descriptionLabel.text = dataFetcher.getDescription(listItem: listItem)
        case 2:
            cell.titleLabel.text = "Release date:"
            cell.descriptionLabel.text = dataFetcher.getDate(from: listItem?.releaseDate)
        case 3:
            cell.titleLabel.text = "Directors:"
            cell.descriptionLabel.text = dataFetcher.getDirectors(from: castAndCrew?.crew)
        case 4:
            cell.titleLabel.text = "Cast:"
            cell.descriptionLabel.text = dataFetcher.getCast(from: castAndCrew?.cast)
        case 5:
            cell.titleLabel.text = "Genres:"
            cell.descriptionLabel.text = dataFetcher.getGenres(from: genres?.genres)
        default: break
        }
        return cell
    }
}
