//
//  UIImageView.swift
//  GeniuseeMovieFinder
//
//  Created by Victor Pelivan on 25.06.2020.
//  Copyright © 2020 Viktor Pelivan. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func setRadiusAndBounds() {
        self.contentMode = .scaleAspectFill
        self.layer.cornerRadius = 5
        self.clipsToBounds = false
        self.layer.masksToBounds = true
    }
}
