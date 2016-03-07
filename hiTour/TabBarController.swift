//
//  TabBarController.swift
//  hiTour
//
//  Created by Dominik Kulon on 07/03/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation
import UIKit

class TabBarController: UITabBarController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
    }
    
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        self.segmentedControl.selectedSegmentIndex = 0
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //segue for the popover configuration window
        if segue.identifier == "showScannerSegue" {
            if let controller = segue.destinationViewController as? UIViewController {
                controller.popoverPresentationController!.delegate = self
                controller.preferredContentSize = CGSize(width: 700, height: 550)
            }
        }
    }
    
}