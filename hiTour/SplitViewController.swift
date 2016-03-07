//
//  SplitViewController.swift
//  hiTour
//
//  Created by Dominik Kulon on 07/03/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation
import UIKit

class SplitViewController: UISplitViewController {
    
    override func viewDidLoad() {
        self.maximumPrimaryColumnWidth = 400
        self.preferredPrimaryColumnWidthFraction = 0.33
    }
}