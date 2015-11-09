//
//  Daily+CoreDataProperties.swift
//  NutriWeekApp
//
//  Created by Jessica Oliveira on 06/11/15.
//  Copyright © 2015 Gabarron. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

class Daily : NSManagedObject{

    @NSManaged var date: NSDate?
    @NSManaged var fled: NSNumber?
    @NSManaged var descriptionStr: String?
    @NSManaged var hasImage: NSNumber?

    /** The designated initializer **/
    convenience init()
    {
        /// Get context
        let context:NSManagedObjectContext = DatabaseManager.sharedInstance.managedObjectContext!
        
        /// Create entity description
        let entityDescription:NSEntityDescription? = NSEntityDescription.entityForName("Daily", inManagedObjectContext: context)
        
        // Call super using
        self.init(entity: entityDescription!, insertIntoManagedObjectContext: context)
    }
}
