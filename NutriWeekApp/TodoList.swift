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
    
    func allItems() -> [TodoItem] {
        var todoDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) ?? [:]
        let items = Array(todoDictionary.values)
        return items.map({TodoItem(deadline: $0["deadline"] as! NSDate, title: $0["title"] as! String, UUID: $0["UUID"] as! String!)}).sorted({(left: TodoItem, right:TodoItem) -> Bool in
            (left.deadline.compare(right.deadline) == .OrderedAscending)
        })
    }
    
    func addItem(item: TodoItem) {
//        var interval: NSCalendarUnit = .CalendarUnitWeek
        
        // persist a representation of this todo item in NSUserDefaults
        var todoDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) ?? Dictionary() // if todoItems hasn't been set in user defaults, initialize todoDictionary to an empty dictionary using nil-coalescing operator (??)
        todoDictionary[item.UUID] = ["deadline": item.deadline, "title": item.title, "UUID": item.UUID] // store NSData representation of todo item in dictionary with UUID as key
        NSUserDefaults.standardUserDefaults().setObject(todoDictionary, forKey: ITEMS_KEY) // save/overwrite todo item list
        
        // create a corresponding local notification
        var notification = UILocalNotification()
        notification.alertBody = "Horário de refeição: \"\(item.title)\" !" // text that will be displayed in the notification
        notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = item.deadline // todo item due date (when notification will be fired)
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.userInfo = ["title": item.title, "UUID": item.UUID] // assign a unique identifier to the notification so that we can retrieve it later
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func removeItem(item: TodoItem) {
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications as! [UILocalNotification] { // loop through notifications...
            if (notification.userInfo!["UUID"] as! String == item.UUID) { // ...and cancel the notification that corresponds to this TodoItem instance (matched by UUID)
                UIApplication.sharedApplication().cancelLocalNotification(notification) // there should be a maximum of one match on UUID
                break
            }
        }
        
        if var todoItems = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) {
            todoItems.removeValueForKey(item.UUID)
            NSUserDefaults.standardUserDefaults().setObject(todoItems, forKey: ITEMS_KEY) // save/overwrite todo item list
        }
    }
    
//    func scheduleReminderforItem(item: TodoItem) {
//        
//        var notification = UILocalNotification() // create a new reminder notification
//        notification.alertBody = "Reminder: Todo Item \"\(item.title)\" Is Overdue" // text that will be displayed in the notification
//        notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
//        notification.fireDate = NSDate().dateByAddingTimeInterval(2 * 60) // 30 minutes from current time
//        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
//        notification.userInfo = ["title": item.title, "UUID": item.UUID] // assign a unique identifier to the notification that we can use to retrieve it later
//        //notification.category = "TODO_CATEGORY"
//        
//        
//        UIApplication.sharedApplication().scheduleLocalNotification(notification)
//        
//        
//    }
    
    
    
//    var localNotification = UILocalNotification()
//    var appDelegate: AppDelegate?
//    
//    
//    
//    func scheduleNotification (dateString: String) -> ()  {
//        
////        var dateString = "2014-07-15" // change to your date format
//        println(dateString)
//        
//        var dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "HH:mm:ss"  //"yyyy-MM-dd"
//        
//        var date = dateFormatter.dateFromString(dateString)
//        
//        println(date)
//        
//        appDelegate = UIApplication.sharedApplication().delegate
//            as? AppDelegate
//        
//        if appDelegate!.eventStore == nil {
//            appDelegate!.eventStore = EKEventStore()
//            appDelegate!.eventStore!.requestAccessToEntityType(
//                EKEntityTypeReminder, completion: {(granted, error) in
//                    if !granted {
//                        println("Access to store not granted")
//                        println(error.localizedDescription)
//                    } else {
//                        println("Access granted")
//                    }
//            })
//        }
//        
//        if (appDelegate!.eventStore != nil) {
//            
//            let reminder = EKReminder(eventStore: appDelegate!.eventStore)
//            
//            reminder.title = "Oi"
//            reminder.calendar =
//                appDelegate!.eventStore!.defaultCalendarForNewReminders()
//            //let date = date
//            let alarm = EKAlarm(absoluteDate: date)
//            
//            reminder.addAlarm(alarm)
//            
//            var error: NSError?
//            appDelegate!.eventStore!.saveReminder(reminder,
//                commit: true, error: &error)
//            
//            if error != nil {
//                println("Reminder failed with error \(error?.localizedDescription)")
//            }
//        }
//        
////        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
////        let myComponents = myCalendar.components(.CalendarUnitWeekday, fromDate: date!)
//////        let weekDay = myComponents.weekday
////        
////        println(date)
////        
////        var repeatCalendar: NSCalendar?
////        //repeatCalendar = .WeekCalendarUnit
////    
////        localNotification.alertAction = "Testing notifications on iOS8"
////        localNotification.alertBody = "Some text here"
////        localNotification.soundName = UILocalNotificationDefaultSoundName
////        localNotification.timeZone = NSTimeZone.localTimeZone()
////    
////        localNotification.fireDate = date
////        //localNotification.repeatCalendar = .CalendarUnitWeekday
////        localNotification.fireDate = NSDate(timeIntervalSinceNow: 10)
////        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
//        
//    }
    
}