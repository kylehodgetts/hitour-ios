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
    @IBOutlet weak var refreshView: UIView!
    

    var currentTour : Tour!
    var quizURL : String!
    
    
    override func viewDidLoad() {
        let isConnected = Reachability.isConnectedToNetwork()
        if isConnected {
            quizURL = currentTour.quizUrl
            webView.loadRequest(NSURLRequest(URL: NSURL(string: quizURL)!))
            webView.keyboardDisplayRequiresUserAction = true
            webView.scrollView.showsHorizontalScrollIndicator = false
        }
        refreshView.hidden = isConnected
    }
    
    @IBAction func doRefresh(sender: UITapGestureRecognizer) {
        viewDidLoad()
    }
    
    
}
