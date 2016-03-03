//
//  DetailViewController.swift
//  hiTour
//
//  Created by Dominik Kulon & Charlie Baker on 23/02/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation
import UIKit

//  
//  View Controller in order to display the detail for a particular point in a tour.
//  This includes a title, description and dyanmic views to populate each peice of data content
//  for that particular point.
class DetailViewController : UIViewController {
    
    var prototypeData : PrototypeDatum! = PrototypeDatum.getAllData[0]
    var textDetail: UITextView!

    //  Outlet reference to the point's image on the storyboard
    @IBOutlet weak var imageDetail: UIImageView!
    
    //  Outlet reference to the point's name title labe on the storyboard
    @IBOutlet weak var titleDetail: UILabel!
    
    //  Outlet reference to the stack view that contains all the dynamic content data views
    @IBOutlet weak var stackView: UIStackView!
    
    //  Outlet reference to the main scroll view for the view controller on the storyboard
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    //  Set's up and instantiates all of the views including setting the values for the point's
    //  title, description and image
    //  Calls the function to populate the view controller with its content data into the stackview
    override func viewDidLoad() {        
        textDetail = UITextView()
        textDetail.editable = false
        textDetail.scrollEnabled = true
        textDetail.selectable = false
        
        stackView.addArrangedSubview(textDetail)
        
        self.imageDetail!.image = UIImage(named: prototypeData.imageName)
        self.imageDetail!.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        
            
        self.titleDetail.text = prototypeData.title
        self.textDetail.text = prototypeData.description
        textDetail.sizeToFit()
        textDetail.heightAnchor.constraintEqualToConstant(textDetail.contentSize.height + 100).active = true
        textDetail.widthAnchor.constraintEqualToConstant(textDetail.contentSize.width).active = true
        
        loadDynamicContent()
    }
    
    //  Loads the point's content data by retrieving and array of its content data then preparing the path to its resource file
    //  to then instantiate a ContentView and populating the content view with the data item's title, description and either a video,
    //  image or text file.
    //  The content view is then added to the stack view in the ranked ordered retirevied.
    func loadDynamicContent() {
        let pointData = PrototypeDatum.getPointData(prototypeData.title)
        
        for item in pointData {
            let urlString = item[PrototypeDatum.DataURLKey]
            let urlFileName = (urlString! as NSString).substringToIndex(Int((urlString?.characters.count)!)-4)
            let urlFileExt = (urlString! as NSString).substringFromIndex(Int((urlString?.characters.count)!)-3)
            
            var contentItem :ContentView!
            let path : String!
            if urlFileExt != "jpg" {
                path = NSBundle.mainBundle().pathForResource(urlFileName, ofType: urlFileExt)
            }
            else {
                path = urlFileName
            }
            
            contentItem = ContentView(frame: CGRect (x: 0, y: 0, width: self.view.bounds.width, height: 350))
            contentItem.populateView(path!, titleText: item[PrototypeDatum.DataTitleKey]!, descriptionText: item[PrototypeDatum.DataDescriptionKey]!)
            contentItem.presentingViewController = self

            contentItem.layoutIfNeeded()
            contentItem.sizeToFit()
            contentItem.heightAnchor.constraintEqualToConstant(contentItem.frame.height).active = true
            contentItem.widthAnchor.constraintEqualToConstant(400).active = true
            
            stackView.addArrangedSubview(contentItem)
        }
        
    }
    
    //  Prepares the view controller segue for when an image is tapped, the image displays full screen for the user to
    //  zoom and pan the image. This function prepares the FullScreenImageViewController with the image that the user has tapped on.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "imageFullScreenSegue" {
            let destination = segue.destinationViewController as! FullScreenImageViewController
            let imageV = sender as! UIImageView
            destination.originalImageView = imageV
        }
    }
}
