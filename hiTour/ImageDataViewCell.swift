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
class ImageDataViewCell: UICollectionViewCell {
    
    /// The title of the point data.
    @IBOutlet weak var title: UILabel!
    
    /// The description of the point data.
    @IBOutlet weak var dataDescription: UITextView!
    
    /// The point data (image).
    @IBOutlet weak var imageView: UIImageView!
    
    /// Reference to the DetailViewController instantiating this view.
    var presentingViewController : DetailViewController!
    
//    func addGestureRecognizer() {
//        let tapFullScreenGesture = UITapGestureRecognizer(target: self, action: Selector("displayImageFullScreen"))
//        tapFullScreenGesture.delegate = self
//        imageView.addGestureRecognizer(tapFullScreenGesture)
//        print("func gesture")
//    }
//    
//    //  Function that handles when an image is tapped so that it is presented full screen by performing a segue to the
//    //  FullScreenImageViewController
//    func displayImageFullScreen() {
//        print("func perform")
//        presentingViewController.performSegueWithIdentifier("imageFullScreenSegue", sender: imageView)
//    }
    
}

class ImageDataView : UIView {
    var contentView: UIView?
    // other outlets
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        NSBundle.mainBundle().loadNibNamed("ImageDataViewCell", owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
    }
}