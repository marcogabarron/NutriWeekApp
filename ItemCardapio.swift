//
//  ItemCardapio.swift
//  NutriWeekApp
//
//  Created by Jessica Oliveira on 13/07/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.
//

import Foundation
import CoreData

class ItemCardapio: NSManagedObject {

    @NSManaged var categoria: String
    @NSManaged var image: String
    @NSManaged var name: String
    @NSManaged var cardapio: NSSet
    
    /** The designated initializer **/
    convenience init()
    {
        /// Get context
        let context:NSManagedObjectContext = DatabaseManager.sharedInstance.managedObjectContext!
        
        /// Create entity description
        let entityDescription:NSEntityDescription? = NSEntityDescription.entityForName("ItemCardapio", inManagedObjectContext: context)
        
        // Call super using
        self.init(entity: entityDescription!, insertIntoManagedObjectContext: context)
    }

}
