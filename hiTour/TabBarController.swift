//
//  TabBarController.swift
//  hiTour
//
//  Created by Dominik Kulon on 07/03/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showScannerSegue" {
            let controller = segue.destinationViewController as! BarcodeScannerViewController
            
            let frameView = self.parentViewController?.splitViewController?.view
            controller.preferredContentSize = CGSize(width: (frameView?.bounds.width)! * 0.65, height: (frameView?.bounds.height)! * 0.8)
            
            controller.modalPresentationStyle = UIModalPresentationStyle.FormSheet;
            controller.delegate = self
        }
    }
}

extension TabBarController: BarcodeScannerDelegate {
    func didModalDismiss(sender: BarcodeScannerViewController) {
        segmentedControl.selectedSegmentIndex = 0
    }
}