//
//  VideoDataViewCell.swift
//  hiTour
//
//  Created by Dominik Kulon on 13/03/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit
import MediaPlayer

/// The data view cell containing the title, description, and video.
class VideoDataViewCell: UICollectionViewCell {
    
    /// The title of the point data.
    @IBOutlet weak var title: UILabel!
    
    /// The description of the point data.
    @IBOutlet weak var dataDescription: UITextView!
    
    /// The point data (video).
    @IBOutlet weak var videStackView: UIStackView!
    
    /// A reference to the AVPlayerViewController for a video added to the videStackView.
    var playerController: AVPlayerViewController?
    
}