//
//  Notifications.swift
//  NutriWeekApp
//
//  Created by Vítor Machado Rocha on 13/07/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.
//

import Foundation

class FormatDates {
    
    var dateFormatter = NSDateFormatter()
    
    /** Receive the day of week and the pickerdate time. Build the notification, returning the date to schedule **/
    func setNotificationDate (notificationWeekDay: String, dateHour: String) -> (NSDate) {
        
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
    
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateDayToAdd = dateFormatter.stringFromDate(currentAddedByInterval)
            
        //Date hour getted in picker date
        let dateStringToAdd = dateDayToAdd + "-" + dateHour + ":00"
        print(dateStringToAdd)
            
        //Transform day  and time in only one date
        dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        var dateToAdd = dateFormatter.dateFromString(dateStringToAdd)
            
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
        
        self.dateFormatter.dateFormat = "HH:mm"
        self.dateFormatter.timeZone = NSTimeZone.localTimeZone()
        let dateValue = dateFormatter.dateFromString(dataString)
        
        let stringFormatted = NSDateFormatter.localizedStringFromDate(dateValue!, dateStyle: .NoStyle, timeStyle: .ShortStyle)
        
        return stringFormatted
        
    }
    
    /** Convert stringDate to Date **/
    func formatStringToDate(dataString: String) -> NSDate{
        
        self.dateFormatter.dateFormat = "HH:mm"
        self.dateFormatter.timeZone = NSTimeZone.localTimeZone()
        
        let dateValue = dateFormatter.dateFromString(dataString)
        
        return dateValue!
        
    }
    
    /** Get date and returns a string formatted to save Refeicao **/
    func formatDateToString(date: NSDate) -> String{
        
        self.dateFormatter.dateFormat = "HH:mm"
        
        let strDate = dateFormatter.stringFromDate(date)
        
        return strDate
        
    }
    
    /** Get current date and set day, month and year string **/
    func formatDateToYearDatString(date: NSDate) -> String{
        
        self.dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let strDate = self.dateFormatter.stringFromDate(date)
        
        return strDate
    }

}

