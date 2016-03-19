//
//  TabBarController.swift
//  hiTour
//
//  Created by Dominik Kulon on 07/03/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation
import UIKit

/// Tab Controller that is displayed as a master view on tablets.
class TabBarController: UITabBarController {
    
    /// Reference to the segmetnted control that launches the Scanner on tablets.
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    /// Launch the BarcodeScannerViewController as a dialog on tablets.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showScannerSegue" {
            let controller = segue.destinationViewController as! BarcodeScannerViewController
            
            let frameView = self.parentViewController?.splitViewController?.view
            controller.preferredContentSize = CGSize(width: (frameView?.bounds.width)! * 0.65, height: (frameView?.bounds.height)! * 0.8)
            
            controller.modalPresentationStyle = UIModalPresentationStyle.FormSheet;
            controller.delegate = self
            
            (UIApplication.sharedApplication().delegate as! AppDelegate).feedController = self.viewControllers![0] as? FeedController
            (UIApplication.sharedApplication().delegate as! AppDelegate).tourController = self.viewControllers![1] as? ToursController
        }
    }
}

/// Delegate for the barcode scanner.
extension TabBarController: BarcodeScannerDelegate {
    
    /// Toggle the segmented control when the dialog disappears.
    func didModalDismiss(sender: BarcodeScannerViewController) {
        segmentedControl.selectedSegmentIndex = 0
    }
    
    /// Assign the tour after scanning a valid tour passphrase.
    func didItemScan(tour: Tour, sender: BarcodeScannerViewController) {
        self.selectedIndex = 0
        (self.selectedViewController as! FeedController).assignTour(tour)
    }
    
    /// Display the point after scanning a valid point passphrase.
    func didPointScan(currentTour: Tour, startIndex: Int, sender: BarcodeScannerViewController) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewControllerTablet") as!DetailViewController
        let pt = currentTour.pointTours![startIndex] as! PointTour
        detailController.point = pt.point!
        detailController.audience = currentTour.audience
        self.showDetailViewController(detailController, sender: self)
    }


}