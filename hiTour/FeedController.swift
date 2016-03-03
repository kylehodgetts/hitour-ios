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
    
    let prototypeData = PrototypeDatum.getAllData
    var selectedItem = 0
    
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

    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FeedControllerCellId", forIndexPath: indexPath) as! FeedControllerCell
        cell.sizeToFit()
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
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewControllerTablet") as!DetailViewController
            detailController.prototypeData = self.prototypeData[indexPath.row]
            self.splitViewController!.showDetailViewController(detailController, sender: self)
        } else {
            let pageView = self.storyboard!.instantiateViewControllerWithIdentifier("FeedPageViewController") as! FeedPageViewController
            pageView.startIndex = indexPath.row
            self.navigationController!.pushViewController(pageView, animated: true)
        }
    }
    
}