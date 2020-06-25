//
//  ModuleBuilder.swift
//  GeniuseeMovieFinder
//
//  Created by Victor Pelivan on 25.06.2020.
//  Copyright © 2020 Viktor Pelivan. All rights reserved.
//

import Foundation
import UIKit

protocol Builder {
    static func CreateListScreen() -> UIViewController
//    static func CreateDetailsScreen(filters: Filters?, presenter: DrinksViewPresenterProtocol?) -> UIViewController
}

class ModuleBuilder: Builder {
    static func CreateListScreen() -> UIViewController {
        let view = ListScreenViewController()
//        let presenter = DrinksViewPresenter(view: view)
//        view.presenter = presenter
        return view
    }
    
//    static func CreateFilters(filters: Filters?, presenter: DrinksViewPresenterProtocol?) -> UIViewController {
//        let view = FiltersViewController()
//        let presenter = FilterViewPresenter(view: view, filters: filters, coctailsPresenter: presenter)
//        view.presenter = presenter
//        return view
//    }
}
