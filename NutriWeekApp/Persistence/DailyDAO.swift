//
//  DailyDAO.swift
//  NutriWeekApp
//
//  Created by Jessica Oliveira on 06/11/15.
//  Copyright © 2015 Gabarron. All rights reserved.
//

import Foundation
import CoreData

class DailyDAO
{
    
    /** Insert element into context and Save context **/
    static func insert(objectToBeInserted: Daily)
    {
        // Insert element into context
        DatabaseManager.sharedInstance.managedObjectContext?.insertObject(objectToBeInserted)
        
        // Save context
        let error: NSErrorPointer = nil
        do {
            try DatabaseManager.sharedInstance.managedObjectContext?.save()
        } catch let error1 as NSError {
            error.memory = error1
        }
        if (error != nil)
        {
            // Log error
            print(error, terminator: "")
        }
    }
    
    /** Remove object from context **/
    static func delete(objectToBeDeleted: Daily)
    {
        // Remove object from context
        let error:NSErrorPointer = nil
        DatabaseManager.sharedInstance.managedObjectContext?.deleteObject(objectToBeDeleted)
        do {
            try DatabaseManager.sharedInstance.managedObjectContext?.save()
        } catch let error1 as NSError {
            error.memory = error1
        }
        
        // Log error
        if (error != nil)
        {
            print(error, terminator: "")
        }
    }
    
    /** creating fetch to find all items **/
    static func findAll() -> [Daily] {
        /// Creating fetch request
        let request = NSFetchRequest(entityName: "Daily")
        
        /// Sort Descriptor to ascending results by name
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true, selector: Selector("localizedCaseInsensitiveCompare:"))
        request.sortDescriptors = [sortDescriptor]
        
        // Perform search
        //var error: NSErrorPointer = nil
        let results: [Daily] = (try! DatabaseManager.sharedInstance.managedObjectContext?.executeFetchRequest(request)) as! [Daily]
        return results
    }
    
    /** Edit element into context and Save context **/
    static func edit(objectToBeInserted: Daily)
    {
        // Save context
        do {
            try DatabaseManager.sharedInstance.managedObjectContext?.save()
        } catch {
            print("\(error)")
        }
    }
    
    /** find the first meal and return true or no find and return false **/
    static func findByDateBool(date: NSDate) -> Bool
    {
        let daily : [Daily] = self.findAll()
        var answer : Bool = false
        
        for day in daily{
            if(day.date == date){
                answer = true
            }
        }
        
        
        return answer
    }
    
    /** find the first meal and return true or no find and return false **/
    static func findByDate(date: NSDate) -> [Daily]
    {
        // Creating fetch request
        let request = NSFetchRequest(entityName: "Daily")
        
//        let dateFormat = NSDateFormatter()
//        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        
        let calendar = NSCalendar.currentCalendar()
        
        let startDateComps = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.TimeZone], fromDate: date)
        
        startDateComps.hour = 0
        startDateComps.minute = 0
        startDateComps.second = 0
        startDateComps.timeZone = NSTimeZone.localTimeZone()

        let dateInit = calendar.dateFromComponents(startDateComps)!

        let endDateComps = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: date)
        
        endDateComps.hour = 23
        endDateComps.minute = 59
        endDateComps.second = 59
        startDateComps.timeZone = NSTimeZone.localTimeZone()
        
        let dateEnd = calendar.dateFromComponents(endDateComps)!
        
        
        
        // Assign predicate
        request.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", dateInit, dateEnd)
        
        // Perform search
        //var error: NSErrorPointer = nil
        let results: [Daily] = (try! DatabaseManager.sharedInstance.managedObjectContext?.executeFetchRequest(request)) as! [Daily]
        
        return results

    }

}