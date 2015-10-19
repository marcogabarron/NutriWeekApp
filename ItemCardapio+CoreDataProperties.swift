//
//  ItemCardapio+CoreDataProperties.swift
//  NutriWeekApp
//
//  Created by Jessica Oliveira on 19/10/15.
//  Copyright © 2015 Gabarron. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ItemCardapio {

    @NSManaged var image: String?
    @NSManaged var name: String?
    @NSManaged var categoria: UNKNOWN_TYPE
    @NSManaged var cardapio: NSSet?

}
