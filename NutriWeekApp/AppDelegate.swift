//
//  AppDelegate.swift
//  NutriWeekApp
//
//  Created by Gabarron on 26/06/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.
//

import UIKit
import EventKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var eventStore: EKEventStore?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
    
        // Create the settings to use register user local notifications
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [UIUserNotificationType.Badge, UIUserNotificationType.Sound, UIUserNotificationType.Alert], categories: nil))
        
        // Configure tracker from GoogleService-Info.plist.
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
//        
//        // Optional: configure GAI options.
//        let gai = GAI.sharedInstance()
//
//        gai.trackUncaughtExceptions = true
//        gai.dispatchInterval = 20
//        gai.logger.logLevel = GAILogLevel.Verbose
//        gai.trackerWithTrackingId("UA-70701653-1")

        
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
    }
    
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
//        var notification = Notifications()
        
////        //Help to see a notification when it is received by user and get UUID or other informations
//                var item = TodoItem(deadline: notification.userInfo!["deadline"] as! NSDate, title: notification.userInfo!["title"] as! String, UUID: notification.userInfo!["UUID"] as! String!)
//        
//                println(notification.userInfo!["UUID"] as! String!)
//        let date = NSDate()
//        var item = TodoItem(deadline: date, title: notification.userInfo!["title"] as! String, UUID: notification.userInfo!["UUID"] as! String!)
        
        print(notification.userInfo!["UUID"] as! String!)

        
    }
    

    
}
