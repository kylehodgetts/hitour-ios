//
//  AppDelegate.swift
//  hiTour
//
//  Created by Kyle Hodgetts on 15/02/2016.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import AVKit
import VideoToolbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack()


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //let httpClient = HTTPClient(baseUrl: "https://hitour.herokuapp.com/api/A7DE6825FD96CCC79E63C89B55F88")
        //ApiConnector(HTTPClient: httpClient, stack: coreDataStack).updateAll()
        

        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.coreDataStack.saveMainContext()
    }
    
    //  
    //  Function that allows landscape rotation when an image or video is viewed full screen
    //  
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
        if self.window?.rootViewController?.presentedViewController is FullScreenImageViewController {
            return UIInterfaceOrientationMask.All
        }
        
        if ((self.window?.rootViewController?.presentedViewController?.isKindOfClass(NSClassFromString("AVFullScreenViewController").self!)) != nil) {
            return UIInterfaceOrientationMask.All
        }
        return UIInterfaceOrientationMask.Portrait
    }

}

