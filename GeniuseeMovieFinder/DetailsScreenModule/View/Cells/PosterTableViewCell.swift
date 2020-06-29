//
//  PosterTableViewCell.swift
//  GeniuseeMovieFinder
//
//  Created by Victor Pelivan on 29.06.2020.
//  Copyright © 2020 Viktor Pelivan. All rights reserved.
//

import UIKit

class PosterTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.setShadowsAndCorners()
        posterImageView.setRadiusAndBounds()
        activityIndicator.isHidden = true
    }
}
