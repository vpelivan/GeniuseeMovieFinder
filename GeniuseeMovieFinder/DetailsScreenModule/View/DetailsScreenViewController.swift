//
//  DetailsScreenViewController.swift
//  GeniuseeMovieFinder
//
//  Created by Victor Pelivan on 25.06.2020.
//  Copyright © 2020 Viktor Pelivan. All rights reserved.
//

import UIKit

class DetailsScreenViewController: UIViewController {

    //MARK: - IBOutlets

    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Variables

    var presenter: DetailsScreenPresenterProtocol!
    
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = presenter?.listItem?.title
        setupTableView()
        proceed()
    }
    
    
    //MARK: - Private Methods

    private func setupTableView() {
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(UINib(nibName: "PosterTableViewCell", bundle: nil), forCellReuseIdentifier: "PosterCell")
        tableView.register(UINib(nibName: "TextTableViewCell", bundle: nil), forCellReuseIdentifier: "TextCell")
        tableView.delegate = self
        tableView.dataSource = self
    }

}


//MARK: - TableView DataSource Methods

extension DetailsScreenViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard presenter.castAndCrew != nil, presenter.genres != nil else { return 3 }
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.row)
        switch indexPath.row {
        case 0: return presenter.getPosterCellData(for: tableView, indexPath: indexPath)
        case 1...5: return presenter.getTextCellData(for: tableView, indexPath: indexPath)
        default: return UITableViewCell()
        }
    }
}


//MARK: - TableView Delegate Methods

extension DetailsScreenViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return UIScreen.main.bounds.width * 1.4
        }
        return UITableView.automaticDimension
    }
}


//MARK: - MVP Protocol Extensions

extension DetailsScreenViewController: DetailsScreenProtocol {
    
    func proceed() {
        tableView.reloadData()
    }
}
