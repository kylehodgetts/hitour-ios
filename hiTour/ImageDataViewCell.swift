//
//  ImageDataViewCell.swift
//  hiTour
//
//  Created by Dominik Kulon on 13/03/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation
import UIKit

/// The data view cell containing the title, description, and image.
class ImageDataViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    /// The title of the point data.
    @IBOutlet weak var title: UILabel!
    
    /// The description of the point data.
    @IBOutlet weak var dataDescription: UITextView!
    
    /// The point data (image).
    @IBOutlet weak var imageView: UIImageView!
    
}