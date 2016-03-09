//
//  FeedPageViewController.swift
//  hiTour
//
//  Created by Dominik Kulon on 24/02/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation

import UIKit

/// Page View Controller that allows swiping between the detail views on a phone.
class FeedPageViewController : UIPageViewController {
    
    // the data instantiated for a prototype
    var points: [PointTour] = []
    
    var audience: Audience!
    
    /// The index of a selected item when the Page View Controller is instantiated.
    var startIndex : Int!
    
    /// Initializes the first view controller and a data source.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        let firstViewController = orderedViewControllers[startIndex]
        setViewControllers([firstViewController],
                direction: .Forward,
                animated: true,
                completion: nil)
    }
    
    /// - Returns: Array of View Controllers that are being managed by the Page View Controller.
    private(set) lazy var orderedViewControllers: [DetailViewController] = {
        var controllers : [DetailViewController] = []
        for index in 0..<self.points.count {
            let dvController = self.newDetailsController()
            dvController.point = self.points[index].point!
            dvController.audience = self.audience
            controllers.append(dvController)
        }
        return controllers
    }()
    
    /// Instantiants a new DetailViewController.
    private func newDetailsController() -> DetailViewController {
        return self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as!DetailViewController
    }
}

/// Implements the Data Source protocol.
extension FeedPageViewController: UIPageViewControllerDataSource {
    
    /// - Returns: An appropriate controller when a users tries to access a previous page.
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
            
            guard let viewControllerIndex = orderedViewControllers.indexOf(viewController as!DetailViewController) else {
                return nil
            }
            
            let previousIndex = viewControllerIndex - 1
            
            guard previousIndex >= 0 else {
                return nil
            }
            
            guard orderedViewControllers.count > previousIndex else {
                return nil
            }
            
            return orderedViewControllers[previousIndex]
    }
    
    /// - Returns: An appropriate controller when a users tries to access a subsequent page.
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
            
            guard let viewControllerIndex = orderedViewControllers.indexOf(viewController as! DetailViewController) else {
                return nil
            }
            
            let nextIndex = viewControllerIndex + 1
            let orderedViewControllersCount = orderedViewControllers.count
            
            guard orderedViewControllersCount != nextIndex else {
                return nil
            }
            
            guard orderedViewControllersCount > nextIndex else {
                return nil
            }
            
            return orderedViewControllers[nextIndex]
    }
    
}
