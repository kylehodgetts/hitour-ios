//
//  ToursControllerCell.swift
//  hiTour
//
//  Created by Dominik Kulon on 24/02/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation

import UIKit

/// Hold outlets for the tour cell.
class ToursControllerCell: UICollectionViewCell {
    
    /// The title of a tour/insititution.
    @IBOutlet weak var labelTitle: UILabel!
    
    /// The tour expiration date.
    @IBOutlet weak var labelDate: UILabel!
}