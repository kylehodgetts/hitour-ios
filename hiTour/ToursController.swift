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
        collectionView!.registerNib(UINib(nibName: "ToursControllerCell", bundle: nil), forCellWithReuseIdentifier: "ToursControllerCellId")
        
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        flowLayout.itemSize = CGSize(width: (screenSize.width - 22) / 2, height: screenSize.height / 3)
    }
    
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
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 6
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let popup = UIAlertController()
        popup.title = "Major 🔑 No " + String(indexPath.row)
        popup.message = "\nIt's just a prototype 💁"
        let popupAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) {
            action in popup.dismissViewControllerAnimated(true, completion: nil)
        }
        popup.addAction(popupAction)
        self.presentViewController(popup, animated: true, completion: nil)
    }
    
}