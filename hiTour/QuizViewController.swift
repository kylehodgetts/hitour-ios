//
//  QuizViewController.swift
//  hiTour
//
//  Created by Charlie Baker on 15/03/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation
import UIKit

///  View Controller to handle the display of the Quiz to the user and handle
///  the network connectivity issues.
class QuizViewController : UIViewController {
    
    ///  Outlet reference to the web container view.
    @IBOutlet weak var webView: UIWebView!
    
    ///  Outlet reference to the refresh view.
    @IBOutlet weak var refreshView: UIView!
    
    ///  Store the currently selected tour.
    var currentTour : Tour!
    
    ///  Store the quizURL.
    var quizURL : String!
    
    ///  Load the view by checking for network connection, if there is connectivity then the
    ///  Quiz is loaded in the web view otherwise the refresh view is shown for the user to press
    ///  when they have connectivity to the internet.
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
    
    ///  Function that handles the action when the refresh icon is tapped in the refresh view.
    @IBAction func doRefresh(sender: UITapGestureRecognizer) {
        viewDidLoad()
    }
    
    
}
