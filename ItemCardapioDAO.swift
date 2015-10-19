

import Foundation
import CoreData

class ItemCardapioDAO
{
    
    /** Insert element into context and Save context **/
    static func insert(objectToBeInserted: ItemCardapio)
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
    static func delete(objectToBeDeleted: ItemCardapio)
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
    static func findAll() -> [ItemCardapio] {
        /// Creating fetch request
        let request = NSFetchRequest(entityName: "ItemCardapio")
        
        /// Sort Descriptor to ascending results by name
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true, selector: Selector("localizedCaseInsensitiveCompare:"))
        request.sortDescriptors = [sortDescriptor]
        
        // Perform search
        //var error: NSErrorPointer = nil
        let results: [ItemCardapio] = (try! DatabaseManager.sharedInstance.managedObjectContext?.executeFetchRequest(request)) as! [ItemCardapio]
        return results
    }
    
    /** find the food with time begin and finish **/
    static func findByTime(horarioInicio: NSDate, horarioFim: NSDate) -> [ItemCardapio]
    {
        /// Creating fetch request
        let request = NSFetchRequest(entityName: "ItemCardapio")
        
        // Assign predicate
        request.predicate = NSPredicate(format: "horarioInicio <= %ld OR horarioFim <= %ld", horarioInicio, horarioFim)
        
        // Assign sort descriptor
        //request.sortDescriptors = [NSSortDescriptor(key: "horarioInicio", ascending:true)]
        
        // Perform search
        //var error: NSErrorPointer = nil
        let results: [ItemCardapio] = (try! DatabaseManager.sharedInstance.managedObjectContext?.executeFetchRequest(request)) as! [ItemCardapio]
        
        return results
    }
    
    /** find the food with name used to predicate **/
    static func findByName(name: String, image: String) -> [ItemCardapio]
    {
        /// Creating fetch request
        let request = NSFetchRequest(entityName: "ItemCardapio")
        
        // Assign predicate
        request.predicate = NSPredicate(format: "name CONTAINS[c] %@ OR image CONTAINS[c] %@", name, image)
        
        // Perform search
       // var error: NSErrorPointer = nil
        let results: [ItemCardapio] = (try! DatabaseManager.sharedInstance.managedObjectContext?.executeFetchRequest(request)) as! [ItemCardapio]
        
        return results
    }
    
    /** find the food with name used to predicate **/
    static func findByCategory(category: String) -> [ItemCardapio]
    {
        /// Creating fetch request
        let request = NSFetchRequest(entityName: "ItemCardapio")
        
        // Assign predicate
        request.predicate = NSPredicate(format: "categoria CONTAINS[c] %@", category)
        
        // Perform search
        // var error: NSErrorPointer = nil
        let results: [ItemCardapio] = (try! DatabaseManager.sharedInstance.managedObjectContext?.executeFetchRequest(request)) as! [ItemCardapio]
        
        return results
    }
    
}