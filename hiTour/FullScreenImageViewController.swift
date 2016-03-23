//
//  FullScreenImageViewController.swift
//  hiTour
//
//  Created by Charlie Baker on 01/03/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation
import UIKit

///  ViewController Class that displays an image full screen allowing zooming and scaling.
class FullScreenImageViewController : UIViewController, UIScrollViewDelegate {
    
    ///  Reference to original image assigned when the segue is prepared for.
    var originalImageView : UIImageView!
    
    ///  Reference to the image view on the storyboard that display the image.
    @IBOutlet weak var imageView: UIImageView!
    
    ///  Reference to the close button on the storyboard.
    @IBOutlet weak var btnClose: UIButton!
    
    ///  Reference to the scrollview on the storyboard.
    @IBOutlet weak var scrollView: UIScrollView!
    
    ///  Function that sets up the views when the view controller is loaded by setting the image to fit in the
    ///  centre of the screen.
    ///  A scrollview delegate is alos attached.
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = originalImageView.image
        imageView.contentMode = .ScaleAspectFit
        scrollView.delegate = self
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }
    
    ///  Function that deals with the action to close the full screen view controller when the
    ///  'X' close button is tapped by the user to dismiss this view controller.
    @IBAction func closeImage(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    ///  Function that allows the pinch zooming of the image.
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
}
