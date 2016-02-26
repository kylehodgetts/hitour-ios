//
//  FeedController.swift
//  hiTour
//
//  Created by Dominik Kulon on 22/02/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation

import UIKit

class FeedController: UICollectionViewController {
        
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var prototypeData:[PrototypeDatum] = []
    var selectedItem = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        
        flowLayout.minimumLineSpacing = 2.0
        
        let savedTour = NSUserDefaults.standardUserDefaults().integerForKey("Tour")
        if savedTour > 0 {
           setTour(savedTour)
        }
        
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FeedControllerCell", forIndexPath: indexPath) as! FeedControllerCell
        let datum = self.prototypeData[indexPath.row]
        
        cell.imageViewFeed?.image = UIImage(named: datum.imageName)
        cell.imageViewFeed?.contentMode = .ScaleAspectFill
        cell.labelTitle.text = datum.title
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.prototypeData.count
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let pageView = self.storyboard!.instantiateViewControllerWithIdentifier("FeedPageViewController") as! FeedPageViewController
        pageView.startIndex = indexPath.row
        self.navigationController!.pushViewController(pageView, animated: true)
        // selectedItem = indexPath.row
        //performSegueWithIdentifier("FeedPageViewSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "FeedPageViewSegue") {
            let viewController = segue.destinationViewController as! FeedPageViewController
            viewController.startIndex = self.selectedItem
        }
    }
    
    func setTour(tour: Int) -> Void {
        //TODO: Proper loading from the core data
        prototypeData = Array(PrototypeDatum.getAllData.dropLast(min(tour, PrototypeDatum.getAllData.count - 1)))
        NSUserDefaults.standardUserDefaults().setInteger(tour, forKey: "Tour")
        collectionView?.reloadData()
    }
    
}