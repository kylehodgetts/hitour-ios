//
//  ToursController.swift
//  hiTour
//
//  Created by Dominik Kulon on 22/02/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation

import UIKit

class ToursController : UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ToursControllerCell", forIndexPath: indexPath) as! ToursControllerCell
        cell.layer.cornerRadius = 7;
        
        // just for ui testing
        var institution : String
        
        switch(indexPath.row) {
            case 0: institution = "Royal Brompton Hospital"
            case 1: institution = "King's College"
            case 2: institution = "National Portrait Gallery"
            case 3: institution = "Tate Modern"
            case 4: institution = "British Museum"
            case 5: institution = "Science Museum"
            default: institution = "Institution"
        }
        
        cell.labelTitle.text = institution
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 6
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //TODO: once data is dinamically loaded pass the correct id of the
        self.tabBarController?.selectedIndex = 0
        let feedControlelr = self.tabBarController?.selectedViewController?.childViewControllers.first! as! FeedController
        feedControlelr.setTour(indexPath.item)
    }
    
}