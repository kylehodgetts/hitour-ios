//
//  ToursController.swift
//  hiTour
//
//  Created by Dominik Kulon on 22/02/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation

import UIKit

/// The collection view that allows switching between tours.
class ToursController : UICollectionViewController {
    
    /// The flow layout responsible for defining position of collection cells.
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    /// Sets up the size of a collection cell wrt the screen size.
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView!.registerNib(UINib(nibName: "ToursControllerCell", bundle: nil), forCellWithReuseIdentifier: "ToursControllerCellId")
        
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            let v = self.storyboard!.instantiateViewControllerWithIdentifier("SplitViewController") as! UISplitViewController
            flowLayout.itemSize = CGSize(width: v.primaryColumnWidth * 0.98, height: screenSize.height / 3)
        } else {
            flowLayout.itemSize = CGSize(width: (screenSize.width - 22) / 2, height: screenSize.height / 3)
        }
    }
    
    /// Defines layout details for each cell.
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ToursControllerCellId", forIndexPath: indexPath) as! ToursControllerCell
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
    
    /// - Returns: The number of items in the collection.
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 6
    }
    
    /// Switches the tour when the cell has been selected.
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

    }
    
}