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
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        flowLayout.itemSize = CGSize(width: screenSize.width, height: 185)

    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FeedControllerCellId", forIndexPath: indexPath) as! FeedControllerCell
        cell.sizeToFit()
        let datum = self.prototypeData[indexPath.row]
        
        cell.imageViewFeed?.image = UIImage(named: datum.imageName)
        cell.imageViewFeed?.contentMode = .ScaleAspectFill
        cell.labelTitle.text = datum.title
        cell.userInteractionEnabled = isPointDiscovered(indexPath)
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.prototypeData.count
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let pageView = self.storyboard!.instantiateViewControllerWithIdentifier("FeedPageViewController") as! FeedPageViewController
        pageView.startIndex = PrototypeDatum.DiscoveredPoints.indexOf(String(indexPath.row))
        self.navigationController!.pushViewController(pageView, animated: true)
        
    }
    
    func isPointDiscovered(indexPath: NSIndexPath) -> Bool {
        return PrototypeDatum.DiscoveredPoints.contains(String(indexPath.row))
    }
    
    override func viewDidAppear(animated: Bool) {
        self.collectionView?.reloadData()
    }
    
}
