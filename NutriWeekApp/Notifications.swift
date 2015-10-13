//
//  Notifications.swift
//  NutriWeekApp
//
//  Created by Vítor Machado Rocha on 13/07/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.
//

import Foundation

class Notifications {
    
    /** Receive the day of week and the pickerdate time. Build the notification, returning the date to schedule **/
    func scheduleNotifications (diaDaSemana: String, dateHour: String) -> (NSDate) {
        
        // Gett the current week day
        let currentDate = NSDate()
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.CalendarUnitWeekday, fromDate: currentDate)
        let weekDay = myComponents.weekday

        var daysTo: NSInteger?
        
        ///Create the notification date day
        
        switch diaDaSemana {
        case "Domingo":
            daysTo = (8 - weekDay ) % 7
                
        case "Segunda":
            daysTo = (9 - weekDay ) % 7
                
        case "Terça":
            daysTo = (10 - weekDay ) % 7
                
        case "Quarta":
            daysTo = (11 - weekDay ) % 7
                
        case "Quinta":
            daysTo = (12 - weekDay ) % 7
                
        case "Sexta":
            daysTo = (13 - weekDay ) % 7
                
        case "Sábado":
            daysTo = (14 - weekDay ) % 7
            
        default:
            print("Error: This day of week is false!")
        }
        
        let interval: NSTimeInterval = NSTimeInterval(daysTo!)
        let currentAdded: NSDate = currentDate.dateByAddingTimeInterval(interval * 60*60*24)
        
        //Day getted
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateDay = dateFormatter.stringFromDate(currentAdded)
            
        //Date hour getted in picker date
        let dateStringToAdd = dateDay + "-" + dateHour + ":00"
        print(dateStringToAdd)
            
        //Add both
        let dateFormatterBack = NSDateFormatter()
        dateFormatterBack.dateFormat = "yyyy-MM-dd-HH:mm:ss"
        dateFormatterBack.timeZone = NSTimeZone.localTimeZone()
        var dateToAdd = dateFormatterBack.dateFromString(dateStringToAdd)
            
        /// Verify if the date generated is before the actual. If its true - only happens if the notification`s day is today early than now - add one week interval
        let dateComparisionResult:NSComparisonResult = currentDate.compare(dateToAdd!)
        
        if dateComparisionResult == NSComparisonResult.OrderedDescending || dateComparisionResult == NSComparisonResult.OrderedSame
        {
            // Current date is greater than end date.
            dateToAdd = dateToAdd?.dateByAddingTimeInterval(60*60*24*7)
        }
        
    return dateToAdd!
        
    }
    
    //MARK - Format Time
    
    /** Get a date string and returns a formatted string with local time zone **/
    func formatStringTime(dataString: String) -> String{
        
        var dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        
        let dateValue = dateFormatter.dateFromString(dataString)
        
        var stringFormatted = NSDateFormatter.localizedStringFromDate(dateValue!, dateStyle: .NoStyle, timeStyle: .ShortStyle)
        
        
        return stringFormatted
        
    }
}