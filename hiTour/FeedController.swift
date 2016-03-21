//
//  FeedController.swift
//  hiTour
//
//  Created by Dominik Kulon & Charlie Baker on 22/02/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation

import UIKit

/// View Controller that displays the feed cells.
class FeedController: UICollectionViewController {
    
    /// Flow layout specifies position of each item in the collection.
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var selectedItem = 0
    var tour: Tour? = nil
    
    /// Registers UINib for the cell layout and the size of each cell wrt the screen size.
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView!.registerNib(UINib(nibName: "FeedControllerCell", bundle: nil), forCellWithReuseIdentifier: "FeedControllerCellId")
        
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        flowLayout.minimumLineSpacing = 2.0

        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            let v = self.storyboard!.instantiateViewControllerWithIdentifier("SplitViewController") as! UISplitViewController
            flowLayout.itemSize = CGSize(width: v.primaryColumnWidth, height: 185)
        } else {
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            flowLayout.itemSize = CGSize(width: screenSize.width, height: 185)
        }
        
        /// Add overlay that says updating....
        let overlay = UIView(frame: self.view.frame)
        let label = UILabel(frame: overlay.frame)
        label.text = "Updating, please wait..."
        label.center = overlay.center
        label.textAlignment = .Center
        overlay.addSubview(label)
        overlay.backgroundColor = UIColor.grayColor()
        overlay.alpha = 0.5
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            tabBarController?.parentViewController?.parentViewController?.view.addSubview(overlay)
        } else {
            tabBarController?.view.addSubview(overlay)
        }
        
        
        /// Update all, remove overlay once update is done
        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        delegate?.getApi()?.updateAll{_ in
            let tourId = NSUserDefaults.standardUserDefaults().integerForKey("Tour")
            if (tourId > 0) {
                if let tour = delegate?.getCoreData().fetch(name: Tour.entityName, predicate: NSPredicate(format: "tourId = %D", tourId))?.last as? Tour {
                    self.assignTour(tour)
                    delegate?.currentTour = tour
                }
            }
            overlay.removeFromSuperview()
        }
        
        
    }

    /// Specifies an image and a title for each cell.
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FeedControllerCellId", forIndexPath: indexPath) as! FeedControllerCell

        guard let t = tour else {
            return cell
        }
        
        if indexPath.row >= t.pointTours?.count {
            cell.labelTitle.text = "Feedback Quiz"
            cell.imageViewFeed.image = UIImage(named: "quizicon")
            cell.imageViewFeed.contentMode = .ScaleAspectFit
            cell.imageViewFeed.backgroundColor = UIColor.init(colorLiteralRed: 255/255.0, green: 203/255.0, blue: 135/255.0, alpha: 1)
            
            let allDiscovered = areAllPointsDiscovered()
            cell.transparentView.hidden = allDiscovered
            cell.userInteractionEnabled = allDiscovered
            cell.lockView.hidden = allDiscovered
        }
        else {
            let pt = t.pointTours![indexPath.row] as! PointTour
            
            cell.labelTitle.text = pt.point?.name
            
            cell.imageViewFeed?.contentMode = .ScaleAspectFill
            cell.userInteractionEnabled = pt.scanned!.boolValue
            cell.lockView.hidden = pt.scanned!.boolValue
            cell.transparentView.hidden = pt.scanned!.boolValue
            
            guard let image = pt.point!.data else {
                return cell
            }
            cell.imageViewFeed.image = UIImage(data: image)
        }
        return cell
    }
    
    /// - Returns: The number of items in the feed collection.
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let t = self.tour {
            return t.pointTours!.count + 1 // 1 added for the Feedback Quiz
        } else {
            return 0
        }
    }
    
    /// Launches the detail view in a master-detail layout for a tablet and in a new View Controller on a phone.
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let t = tour else {
            return
        }
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            if indexPath.row >= t.pointTours?.count {
                let quizView = self.storyboard!.instantiateViewControllerWithIdentifier("QuizViewController") as! QuizViewController
                quizView.currentTour = tour
                
                self.splitViewController?.showDetailViewController(quizView, sender: self)
            }
            else {
                let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewControllerTablet") as!DetailViewController
                
                let pt = t.pointTours![indexPath.row] as! PointTour
                detailController.point = pt.point!
                detailController.audience = t.audience!
                
                self.splitViewController!.showDetailViewController(detailController, sender: self)
            }
        }
        else if indexPath.row >= t.pointTours?.count {
            let quizView = self.storyboard!.instantiateViewControllerWithIdentifier("QuizViewController") as! QuizViewController
            quizView.currentTour = tour
            self.navigationController?.pushViewController(quizView, animated: true)
        }
        else {
            let pageView = self.storyboard!.instantiateViewControllerWithIdentifier("FeedPageViewController") as! FeedPageViewController
            pageView.audience = t.audience!
            pageView.points = t.pointTours!.array.map({$0 as! PointTour})
            let pt = t.pointTours![indexPath.row] as! PointTour
            pageView.startIndex = foundPoints().indexOf(pt)
            self.navigationController!.pushViewController(pageView, animated: true)
        }
    }
    
    /// Loads all currently discovered points and returns a PointTour array
    func foundPoints() -> [PointTour] {
        let allPoints = tour?.pointTours?.array as! [PointTour]
        var discoveredPoints : [PointTour] = []
        for point in allPoints {
            if point.scanned == true {
                discoveredPoints.append(point)
            }
        }
        return discoveredPoints
    }
    
    /// Reloads all the cells with their updated states
    override func viewDidAppear(animated: Bool) {
        self.collectionView?.reloadData()
        
    }
    
    /// Assigns the currently selected tour
    func assignTour(tour: Tour) -> Void {
        self.tour = tour
        NSUserDefaults.standardUserDefaults().setInteger(tour.tourId!.integerValue, forKey: "Tour")
        collectionView?.reloadData()
    }
    
    func areAllPointsDiscovered() -> Bool {
        let points = tour?.pointTours?.array as! [PointTour]
        for point in points {
            if point.scanned == false {
                return false
            }
        }
        return true
    }
    
}
