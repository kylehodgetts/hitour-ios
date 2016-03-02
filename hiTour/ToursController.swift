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
    var tours: [Tour] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        updateTours()
        
        
    }
    
    func updateTours() {
        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        let coredata = delegate?.getCoreData()
        
        guard let nTours = coredata?.fetch(name: Tour.entityName).flatMap({$0 as? [Tour]}) else {
            return
        }
        
        tours = nTours
        collectionView?.reloadData()
        
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ToursControllerCell", forIndexPath: indexPath) as! ToursControllerCell
        cell.layer.cornerRadius = 7;
        
        // just for ui testing
        let institution : String = tours[indexPath.row].name!

        
        cell.labelTitle.text = institution
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return tours.count
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //TODO: once data is dinamically loaded pass the correct id of the
        self.tabBarController?.selectedIndex = 0
        let feedControlelr = self.tabBarController?.selectedViewController?.childViewControllers.first! as! FeedController
        feedControlelr.assignTour(tours[indexPath.row])
    }
    
}