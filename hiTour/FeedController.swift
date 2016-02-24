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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        
        flowLayout.minimumLineSpacing = 2.0
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
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        detailController.prototypeData = self.prototypeData[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    
}