//
//  Notifications.swift
//  NutriWeekApp
//
//  Created by Vítor Machado Rocha on 13/07/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.
//

import Foundation

class Notifications {
    
    let day: NSTimeInterval = 60*60*24
    
    func listNotifications (weekArray: Array<String>, dateHour: String) -> (Array<NSDate>) {
        
        var listOfDates = Array<NSDate>()
        
        let currentDate = NSDate()
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.CalendarUnitWeekday, fromDate: currentDate)
        let weekDay = myComponents.weekday
        
        var currentAdded: NSDate?
        
        for buildNotifications in weekArray {
            
            switch buildNotifications {
            case "Domingo":
                var daysTo: NSInteger = (8 - weekDay ) % 7
                var interval: NSTimeInterval = NSTimeInterval(daysTo)
                currentAdded = currentDate.dateByAddingTimeInterval(interval * day)
                
            case "Segunda":
                var daysTo: NSInteger = (9 - weekDay ) % 7
                var interval: NSTimeInterval = NSTimeInterval(daysTo)
                currentAdded = currentDate.dateByAddingTimeInterval(interval * day)
                
            case "Terça":
                var daysTo: NSInteger = (10 - weekDay ) % 7
                var interval: NSTimeInterval = NSTimeInterval(daysTo)
                currentAdded = currentDate.dateByAddingTimeInterval(interval * day)
                
            case "Quarta":
                var daysTo: NSInteger = (11 - weekDay ) % 7
                var interval: NSTimeInterval = NSTimeInterval(daysTo)
                currentAdded = currentDate.dateByAddingTimeInterval(interval * day)
                
            case "Quinta":
                var daysTo: NSInteger = (12 - weekDay ) % 7
                var interval: NSTimeInterval = NSTimeInterval(daysTo)
                currentAdded = currentDate.dateByAddingTimeInterval(interval * day)
                
            case "Sexta":
                var daysTo: NSInteger = (13 - weekDay ) % 7
                var interval: NSTimeInterval = NSTimeInterval(daysTo)
                currentAdded = currentDate.dateByAddingTimeInterval(interval * day)
                
            case "Sábado":
                var daysTo: NSInteger = (14 - weekDay ) % 7
                var interval: NSTimeInterval = NSTimeInterval(daysTo)
                currentAdded = currentDate.dateByAddingTimeInterval(interval * day)
                
            default:
                println("Error: This day of week is false!")
            }
            
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateDay = dateFormatter.stringFromDate(currentAdded!)
            
            let dateStringToAdd = dateDay + "-" + dateHour
            println(dateStringToAdd)
            
            let dateFormatterBack = NSDateFormatter()
            dateFormatterBack.dateFormat = "yyyy-MM-dd-HH:mm:ss"
            var dateToAdd = dateFormatterBack.dateFromString(dateStringToAdd)
            
            var dateComparisionResult:NSComparisonResult = currentDate.compare(dateToAdd!)
            
            if dateComparisionResult == NSComparisonResult.OrderedDescending || dateComparisionResult == NSComparisonResult.OrderedSame
            {
                // Current date is greater than end date.
                dateToAdd = dateToAdd?.dateByAddingTimeInterval(60*60*24*7)
            }
    
            
            listOfDates.append(dateToAdd!)
            
        }
        
        return listOfDates
        
    }
    
    
    
    
}