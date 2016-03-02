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
    
    var selectedItem = 0
    var tour: Tour? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        
        flowLayout.minimumLineSpacing = 2.0
        
        let savedTour = NSUserDefaults.standardUserDefaults().integerForKey("Tour")
        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        let coredata = delegate?.getCoreData()
        
        if savedTour > 0 {
            guard let sTour = coredata?.fetch(name: Tour.entityName, predicate: NSPredicate(format: "tourId == \(savedTour)")).flatMap({$0.first as? Tour}) else {
                return
            }
            assignTour(sTour)
        }
        
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FeedControllerCell", forIndexPath: indexPath) as! FeedControllerCell
//        let datum = self.tour.prototypeData[indexPath.row]
//        
//        cell.imageViewFeed?.image = UIImage(named: datum.imageName)
//        cell.imageViewFeed?.contentMode = .ScaleAspectFill
//        cell.labelTitle.text = datum.title
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let t = self.tour {
            return t.pointTours!.count
        } else {
            return 0
        }
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
    
    func assignTour(tour: Tour) -> Void {
        //TODO: Proper loading from the core data
        self.tour = tour
        NSUserDefaults.standardUserDefaults().setInteger(tour.tourId!.integerValue, forKey: "Tour")
        collectionView?.reloadData()
    }
    
}