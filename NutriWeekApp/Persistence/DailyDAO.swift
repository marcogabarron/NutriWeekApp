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

}