//
//  FeedControllerCell.swift
//  hiTour
//
//  Created by Dominik Kulon on 22/02/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation

import UIKit

/// Holds outlets for the feed cell.
class FeedControllerCell: UICollectionViewCell {
    
    /// Image showing a specific point.
    @IBOutlet weak var imageViewFeed: UIImageView!
    
    /// The title of a point.
    @IBOutlet weak var labelTitle: UILabel!
    
    /// Reference to the lock icon.
    @IBOutlet weak var lockView: UIView!

    /// Reference to the transparent background icon.
    @IBOutlet weak var transparentView: UIView!

}
