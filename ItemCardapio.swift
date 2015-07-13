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

    @NSManaged var horarioFim: NSDate
    @NSManaged var horarioInicio: NSDate
    @NSManaged var image: String
    @NSManaged var name: String
    @NSManaged var cardapio: NSSet
    
    /// The designated initializer
    convenience init()
    {
        // get context
        let context:NSManagedObjectContext = DatabaseManager.sharedInstance.managedObjectContext!
        
        // create entity description
        let entityDescription:NSEntityDescription? = NSEntityDescription.entityForName("ItemCardapio", inManagedObjectContext: context)
        
        // call super using
        self.init(entity: entityDescription!, insertIntoManagedObjectContext: context)
    }

}
