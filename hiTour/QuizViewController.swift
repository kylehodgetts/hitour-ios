//
//  QuizViewController.swift
//  hiTour
//
//  Created by Charlie Baker on 15/03/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation
import UIKit

//  View controller to handle the display of the Quiz to the user and handle 
//  the network connectivity issues
class QuizViewController : UIViewController {
    
    //  Outlet reference to the web container view
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
