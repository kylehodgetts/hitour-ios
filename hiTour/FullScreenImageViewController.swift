//
//  FullScreenImageViewController.swift
//  hiTour
//
//  Created by Charlie Baker on 01/03/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation
import UIKit


class FullScreenImageViewController : UIViewController, UIScrollViewDelegate {
    
    var originalImageView : UIImageView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = originalImageView.image
        imageView.contentMode = .ScaleAspectFit
        scrollView.delegate = self
    }
    
    
    @IBAction func closeImage(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
}
