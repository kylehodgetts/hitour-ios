//
//  FullScreenImageViewController.swift
//  hiTour
//
//  Created by Charlie Baker on 01/03/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation
import UIKit


class FullScreenImageViewController : UIViewController{
    
    var originalImageView : UIImageView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    @IBOutlet var pinchGesture: UIPinchGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = originalImageView.image
        imageView.contentMode = .ScaleAspectFit
    }
    
    
    @IBAction func handleTapGesture(sender: UITapGestureRecognizer) {
        if sender.numberOfTouches() == 2 {
            let zoomToRect = CGRect(origin: sender.locationInView(imageView), size: CGSize(width: 10, height: 10))
            scrollView.zoomToRect(zoomToRect, animated: true)
        }
    }
    
    
    @IBAction func closeImage(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func handlePinchGesture(sender: UIPinchGestureRecognizer) {
        print("Pinch detected")
        scrollView.transform = CGAffineTransformScale(scrollView.transform,
            sender.scale, sender.scale)
        sender.scale = 1
    }
    
    
}
