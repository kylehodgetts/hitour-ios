//
//  FeedPageViewController.swift
//  hiTour
//
//  Created by Dominik Kulon on 24/02/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation

import UIKit

class FeedPageViewController : UIPageViewController {
    
    // the data instantiated for a prototype
    let prototypeData = PrototypeDatum.getAllData
    
    var startIndex : Int!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        detailController.prototypeData = self.prototypeData[startIndex]
        
        setViewControllers([detailController], direction: .Forward, animated: true, completion: nil)
        
    }
}

extension FeedPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
            var beforeController : DetailViewController? = nil
            
            if(!(startIndex <= 0)) {
                startIndex = startIndex - 1
                beforeController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as? DetailViewController
                beforeController!.prototypeData = self.prototypeData[startIndex]
            }
            
            return beforeController
    }
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
            var afterController : DetailViewController? = nil
            
            if(!(startIndex >= prototypeData.count - 1)) {
                startIndex = startIndex + 1
                afterController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as? DetailViewController
                afterController!.prototypeData = self.prototypeData[startIndex]
            }
            
            return afterController
    }
    
}