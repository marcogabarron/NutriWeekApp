//
//  Notifications.swift
//  NutriWeekApp
//
//  Created by Vítor Machado Rocha on 13/07/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.
//

import Foundation

extension NSDateFormatter {
    
//    var dateFormatter = NSDateFormatter()
    
    /** Receive the day of week and the pickerdate time. Build the notification, returning the date to schedule **/
    public func setNotificationDate (notificationWeekDay: String, dateHour: String) -> (NSDate) {
        
        // Get the current week day
        let currentDate = NSDate()
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.Weekday, fromDate: currentDate)
        let weekDay = myComponents.weekday

        var daysTo: NSInteger?
        
        //Create the notification date day
        //It gets the interval(daysTo) between today and the nearest weekDay selected to add a notification
        //It gets the lowest number wich subtracted by the representative weekday number returns 0 to rest of division by 7(number of days on week).
        //If the rest of division is 0, the weekDay to add is the same of today. If is not 0, the weekday to add is another day.
        //Example: if today is wednesday and I want to add friday -> 13 - 4 = 9. 9%7 = 2. From today to friday there is two days.
        switch notificationWeekDay {
            
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
            print("Error: Unrecognized day")
        }
        
        ///Interval betwwen today and the weekday I want to add
        let interval: NSTimeInterval = NSTimeInterval(daysTo!)
        let currentAddedByInterval: NSDate = currentDate.dateByAddingTimeInterval(interval * 60*60*24)
    
//        var dateFormatter = NSDateFormatter()
        dateFormat = "yyyy-MM-dd"
        let dateDayToAdd = stringFromDate(currentAddedByInterval)
            
        //Date hour getted in picker date
        let dateStringToAdd = dateDayToAdd + "-" + dateHour + ":00"
        print(dateStringToAdd)
            
        //Transform day  and time in only one date
        dateFormat = "yyyy-MM-dd-HH:mm:ss"
        timeZone = NSTimeZone.localTimeZone()
        var dateToAdd = dateFromString(dateStringToAdd)
            
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
    public func formatStringTime(dataString: String) -> String{
        
        dateFormat = "HH:mm"
        timeZone = NSTimeZone.localTimeZone()
        let dateValue = dateFromString(dataString)
        
        let stringFormatted = NSDateFormatter.localizedStringFromDate(dateValue!, dateStyle: .NoStyle, timeStyle: .ShortStyle)
        
        return stringFormatted
        
        
    }
    
    public static func formatStringToDate(str: String, mask: String) {
    
    }
    
    /** Convert stringDate to Date **/
    public func formatStringToDate(dataString: String) -> NSDate{
        
        dateFormat = "HH:mm"
        timeZone = NSTimeZone.localTimeZone()
        
        let dateValue = dateFromString(dataString)
        
        return dateValue!
        
    }
    
    /** Get date and returns a string formatted to save Refeicao **/
    public func formatDateToString(date: NSDate) -> String{
        
        dateFormat = "HH:mm"
        
        let strDate = stringFromDate(date)
        
        return strDate
        
    }
    
    /** Get date and returns a string formatted to save Refeicao **/
    public func formatDateToStringWithSecounds(date: NSDate) -> String{
        
        dateFormat = "HH:mm:ss"
        
        let strDate = stringFromDate(date)
        
        return strDate
        
    }
    
    /** Get current date and set day, month and year string **/
    public func formatDateToYearDateString(date: NSDate) -> String{
        
        dateFormat = "dd/MM/yyyy"
        
        let strDate = stringFromDate(date)
        
        return strDate
    }
    
    /** Get current date and set day, month and year string **/
    public func formatDateToDateString(date: NSDate) -> String{
        
        dateFormat = "yyyy-MM-dd"
        
        let strDate = stringFromDate(date)
        
        return strDate
    }
    
    /** Get current date and set day, month and year string **/
    public func formatCompleteStringToDate(str: String) -> NSDate{
       
        let formatter = NSDateFormatter()

        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = NSTimeZone.localTimeZone()

        let strDate = formatter.dateFromString(str)

        
        return strDate!
    }

}

