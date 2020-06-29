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
    static func CreateDetailsScreen(listItem: Result?) -> UIViewController
}

class ModuleBuilder: Builder {
    static func CreateListScreen() -> UIViewController {
        let view = ListScreenViewController()
        let presenter = ListScreenPresenter(view: view)
        view.presenter = presenter
        return view
    }
    
    static func CreateDetailsScreen(listItem: Result?) -> UIViewController {
        let view = DetailsScreenViewController()
        let presenter = DetailsScreenPresenter(view: view, listItem: listItem)
        view.presenter = presenter
        return view
    }
}
