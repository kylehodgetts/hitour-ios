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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        let firstViewController = orderedViewControllers[startIndex]
        setViewControllers([firstViewController],
                direction: .Forward,
                animated: true,
                completion: nil)
    }
    
    private(set) lazy var orderedViewControllers: [DetailViewController] = {
        var controllers : [DetailViewController] = []
        for index in 0..<self.prototypeData.count {
            let dvController = self.newDetailsController()
            dvController.prototypeData = self.prototypeData[index]
            controllers.append(dvController)
        }
        return controllers
    }()
    
    private func newDetailsController() -> DetailViewController {
        return self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as!DetailViewController
    }
}

extension FeedPageViewController: UIPageViewControllerDataSource {
    
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