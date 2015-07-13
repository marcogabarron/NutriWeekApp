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

class Notification {
    
    var localNotification = UILocalNotification()
    var appDelegate: AppDelegate?
    
    
    
    func scheduleNotification (dateString: String) -> ()  {
        
//        var dateString = "2014-07-15" // change to your date format
        println(dateString)
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"  //"yyyy-MM-dd"
        
        var date = dateFormatter.dateFromString(dateString)
        
        println(date)
        
        appDelegate = UIApplication.sharedApplication().delegate
            as? AppDelegate
        
        if appDelegate!.eventStore == nil {
            appDelegate!.eventStore = EKEventStore()
            appDelegate!.eventStore!.requestAccessToEntityType(
                EKEntityTypeReminder, completion: {(granted, error) in
                    if !granted {
                        println("Access to store not granted")
                        println(error.localizedDescription)
                    } else {
                        println("Access granted")
                    }
            })
        }
        
        if (appDelegate!.eventStore != nil) {
            
            let reminder = EKReminder(eventStore: appDelegate!.eventStore)
            
            reminder.title = "Oi"
            reminder.calendar =
                appDelegate!.eventStore!.defaultCalendarForNewReminders()
            //let date = date
            let alarm = EKAlarm(absoluteDate: date)
            
            reminder.addAlarm(alarm)
            
            var error: NSError?
            appDelegate!.eventStore!.saveReminder(reminder,
                commit: true, error: &error)
            
            if error != nil {
                println("Reminder failed with error \(error?.localizedDescription)")
            }
        }
        
//        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
//        let myComponents = myCalendar.components(.CalendarUnitWeekday, fromDate: date!)
////        let weekDay = myComponents.weekday
//        
//        println(date)
//        
//        var repeatCalendar: NSCalendar?
//        //repeatCalendar = .WeekCalendarUnit
//    
//        localNotification.alertAction = "Testing notifications on iOS8"
//        localNotification.alertBody = "Some text here"
//        localNotification.soundName = UILocalNotificationDefaultSoundName
//        localNotification.timeZone = NSTimeZone.localTimeZone()
//    
//        localNotification.fireDate = date
//        //localNotification.repeatCalendar = .CalendarUnitWeekday
//        localNotification.fireDate = NSDate(timeIntervalSinceNow: 10)
//        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        
    }
    
}