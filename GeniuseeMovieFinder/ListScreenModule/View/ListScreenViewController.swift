//
//  ListScreenViewController.swift
//  GeniuseeMovieFinder
//
//  Created by Victor Pelivan on 25.06.2020.
//  Copyright © 2020 Viktor Pelivan. All rights reserved.
//

import UIKit

class ListScreenViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Variables
    
    var presenter: ListScreenPresenterProtocol!
    var searchController: UISearchController!
    
    //MARK: - Lyfecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Movie Finder"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupTableView()
        setupSearchBar()
    }
    
    //MARK: - Private Methods
    private func setupTableView() {
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(UINib(nibName: "ListScreenTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.placeholder = "Search for movie"
    }
    
    //MARK: - The next function adds found results during search in filteredResultsArray
    private func filterContentFor(searchText text: String) {
        //        filteredResultsArray = allBreeds.filter{ (breed) -> Bool in
        //            return (breed.name?.lowercased().contains(text.lowercased()))!
        
        
    }
    
}


//MARK: - TableView DataSource Methods

extension ListScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rowsNumber = presenter.listItems?.results?.count else { return 0 }
        return rowsNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return presenter.getCellData(for: tableView, indexPath: indexPath)
    }
    
}


//MARK: - TableView Delegate Methods

extension ListScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let listItem = self.presenter.listItems?.results?[indexPath.row] else { return }
        let detailsVC = ModuleBuilder.CreateDetailsScreen(listItem: listItem)
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
}


//MARK: - MVP Protocol Extensions

extension ListScreenViewController: ListScreenProtocol {
    func proceed() {
        tableView.reloadData()
    }
}

extension ListScreenViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentFor(searchText: searchController.searchBar.text!)
        tableView.reloadData()
    }
}
