//
//  Notification.swift
//  NutriWeekApp
//
//  Created by Vítor Machado Rocha on 09/07/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.
//

import Foundation
import UIKit
import EventKit

class TodoList {
    
    class var sharedInstance : TodoList {
        struct Static {
            static let instance : TodoList = TodoList()
        }
        return Static.instance
    }
    
    private let ITEMS_KEY = "todoItems"
    
    /** Show the itens scheduled to notification **/
    func allItems() -> [TodoItem] {
        let todoDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) ?? [:]
        let items = Array(todoDictionary.values)
        return items.map({TodoItem(deadline: $0["deadline"] as! NSDate, title: $0["title"] as! String, UUID: $0["UUID"] as! String!)}).sort({(left: TodoItem, right:TodoItem) -> Bool in
            (left.deadline.compare(right.deadline) == .OrderedAscending)
        })
    }
    
    /** Add new notifications, with repeat interval. **/
    func addItem(item: TodoItem) {
        let weekInterval: NSCalendarUnit = .WeekOfYear
        
        /// persist a representation of this todo item in NSUserDefaults
        var todoDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) ?? Dictionary() // if todoItems hasn't been set in user defaults, initialize todoDictionary to an empty dictionary using nil-coalescing operator (??)
        todoDictionary[item.UUID] = ["deadline": item.deadline, "title": item.title, "UUID": item.UUID] // store NSData representation of todo item in dictionary with UUID as key
        NSUserDefaults.standardUserDefaults().setObject(todoDictionary, forKey: ITEMS_KEY) // save/overwrite todo item list
        
        /// create a corresponding local notification
        let notification = UILocalNotification()
        notification.alertBody = "Horário de refeição: \"\(item.title)\" !" // text that will be displayed in the notification
        notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = item.deadline // todo item due date (when notification will be fired)
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.repeatInterval = weekInterval
        notification.userInfo = ["title": item.title, "UUID": item.UUID] // assign a unique identifier to the notification so that we can retrieve it later
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    /** Remove itens of notifications list **/
    func removeItem(item: TodoItem) {
        if let scheduledLocalNotifications = UIApplication.sharedApplication().scheduledLocalNotifications {
        for notification in scheduledLocalNotifications{ // loop through notifications...
            if (notification.userInfo!["UUID"] as! String == item.UUID) { // ...and cancel the notification that corresponds to this TodoItem instance (matched by UUID)
                UIApplication.sharedApplication().cancelLocalNotification(notification) // there should be a maximum of one match on UUID
                break
            }
            }}
        
        if var todoItems = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) {
            todoItems.removeValueForKey(item.UUID)
            NSUserDefaults.standardUserDefaults().setObject(todoItems, forKey: ITEMS_KEY) // save/overwrite todo item list
        }
    }
    
    func editItem(item: TodoItem) {
        
        if let scheduledLocalNotifications = UIApplication.sharedApplication().scheduledLocalNotifications {
            for notification in scheduledLocalNotifications{ // loop through notifications...
                if (notification.userInfo!["UUID"] as! String == item.UUID) {
                  
                    notification.fireDate = item.deadline // todo item due date (when notification will be fired)
                    notification.userInfo = ["title": item.title, "UUID": item.UUID] // assign a unique identifier to the notification so that we can retrieve it later
                    
                    UIApplication.sharedApplication().scheduleLocalNotification(notification)
                    
                }
            }
        }
    }

    
}