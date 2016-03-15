//
//  QuizViewController.swift
//  hiTour
//
//  Created by Charlie Baker on 15/03/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation
import UIKit


class QuizViewController : UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let coreData = delegate.getCoreData()
        
        
        
    }
    
    
}
