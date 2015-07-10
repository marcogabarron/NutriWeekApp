//
//  Notification.swift
//  NutriWeekApp
//
//  Created by Vítor Machado Rocha on 09/07/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.
//

import Foundation
import UIKit


class Notification {
    
    var localNotification = UILocalNotification()
    
    func scheduleNotification (dateString: String) -> ()  {
        
//        var dateString = "2014-07-15" // change to your date format
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"  //"yyyy-MM-dd"
        
        var date = dateFormatter.dateFromString(dateString)
        
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.CalendarUnitWeekday, fromDate: date!)
//        let weekDay = myComponents.weekday
        
        println(date)
    
        localNotification.alertAction = "Testing notifications on iOS8"
        localNotification.alertBody = "Some text here"
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.timeZone = NSTimeZone.localTimeZone()
    
        localNotification.fireDate = date
//        localNotification.repeatInterval = .CalendarUnitWeek
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 10)
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        
    }
    
}