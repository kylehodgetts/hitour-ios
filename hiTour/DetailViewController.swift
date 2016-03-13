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
class DetailViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //  Reference variable to a point
    var point : Point?
    
    // Reference to audience that this point if for
    var audience: Audience!
    
    //  Reference variable to populate the point description text
    var textDetail: UITextView!
    
    var pointData: [PointData]!

    //  Outlet reference to the point's image on the storyboard
    @IBOutlet weak var imageDetail: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //  Outlet reference to the point's name title labe on the storyboard
    @IBOutlet weak var titleDetail: UILabel!
    
    //  Outlet reference to the main scroll view for the view controller on the storyboard
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    //  Set's up and instantiates all of the views including setting the values for the point's
    //  title, description and image
    //  Calls the function to populate the view controller with its content data into the stackview
    override func viewDidLoad() {
        collectionView!.delegate = self
        collectionView!.dataSource = self
        collectionView!.registerNib(UINib(nibName: "ImageDataViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageDataViewCellId")
        collectionView!.registerNib(UINib(nibName: "TextDataViewCell", bundle: nil), forCellWithReuseIdentifier: "TextDataViewCellId")
        collectionView!.registerNib(UINib(nibName: "VideoDataViewCell", bundle: nil), forCellWithReuseIdentifier: "VideoDataViewCellId")
        
        flowLayout.minimumLineSpacing = 0.0
        
        guard let t = point, imageData = point!.data else {
            return
        }
        
        pointData = point!.getPointDataFor(audience)
        self.imageDetail!.image = UIImage(data: imageData)
        self.imageDetail!.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        
            
        self.titleDetail.text = t.name
//        self.textDetail.text = t.descriptionP
        //                contentItem.populateView(data.data!.data!, titleText: data.data!.title!, descriptionText: data.data!.descriptionD!, url: data.data!.url!, dataId: "\(data.data!.dataId!)-\(audience.audienceId!)")
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TextDataViewCellId", forIndexPath: indexPath) as! TextDataViewCell
        cell.title.text = pointData[indexPath.row].data!.title!
        cell.dataDescription.text = pointData[indexPath.row].data!.descriptionD!
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pointData.count
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
    
    // Closes down the view by ensuring any videos that are playing are stopped when the view is dismissed
    override func viewDidDisappear(animated: Bool) {
//        let subviews = self.stackView.subviews
//        for subview in subviews {
//            if subview is ContentView {
//                let contentView = subview as! ContentView
//                if contentView.videoPlayer != nil && contentView.videoPlayer.rate != 0 && contentView.videoPlayer.error == nil {
//                    contentView.videoPlayer.pause()
//                }
//            }
//        }
    }
    
    // Clears the stack view items of content data for it to be reloaded with up to to date content from core data
//    func clearStackView() {
//        let stackViewItems = stackView.arrangedSubviews
//        for item in stackViewItems {
//            if item is ContentView {
//                stackView.removeArrangedSubview(item)
//            }
//        }
//    }
    
    
}
