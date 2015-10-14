//
//  Refeicao.swift
//  NutriWeekApp
//
//  Created by Jessica Oliveira on 13/07/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.
//

import Foundation
import CoreData

class Refeicao: NSManagedObject {

    @NSManaged var diaSemana: String
    @NSManaged var horario: String
    @NSManaged var name: String
    @NSManaged var refeicao: NSSet
    @NSManaged var uuid: String

    
    /** The designated initializer **/
    convenience init()
    {
        /// Get context
        let context:NSManagedObjectContext = DatabaseManager.sharedInstance.managedObjectContext!
        
        /// Create entity description
        let entityDescription:NSEntityDescription? = NSEntityDescription.entityForName("Refeicao", inManagedObjectContext: context)
        
        // Call super using
        self.init(entity: entityDescription!, insertIntoManagedObjectContext: context)
    }
    
    /** with array of itemsCardapio you set Relationship for NSSet **/
    func addItemsObject(value: ItemCardapio) {
        let mutableSet = self.mutableSetValueForKey("refeicao")
        mutableSet.addObject(value)
        
    }
    
    /** transform the Relationship (NSSet) in array of itemsCardapio **/
    func getItemsObject()->[ItemCardapio]{
        var itemFromRefeicao: [ItemCardapio] = []
        let refeicao = self.mutableSetValueForKey("refeicao")
        for item in refeicao{
            itemFromRefeicao.append(item as! ItemCardapio)
        }
        return itemFromRefeicao
    }

}
