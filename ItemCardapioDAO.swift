

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
        var error: NSErrorPointer = nil
        DatabaseManager.sharedInstance.managedObjectContext?.save(error)
        if (error != nil)
        {
            // Log error
            print(error)
        }
    }
    
    /** Remove object from context **/
    static func delete(objectToBeDeleted: ItemCardapio)
    {
        // Remove object from context
        var error:NSErrorPointer = nil
        DatabaseManager.sharedInstance.managedObjectContext?.deleteObject(objectToBeDeleted)
        DatabaseManager.sharedInstance.managedObjectContext?.save(error)
        
        // Log error
        if (error != nil)
        {
            print(error)
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
        var error: NSErrorPointer = nil
        let results: [ItemCardapio] = DatabaseManager.sharedInstance.managedObjectContext?.executeFetchRequest(request, error: error) as! [ItemCardapio]
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
        var error: NSErrorPointer = nil
        let results: [ItemCardapio] = DatabaseManager.sharedInstance.managedObjectContext?.executeFetchRequest(request, error: error) as! [ItemCardapio]
        
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
        var error: NSErrorPointer = nil
        let results: [ItemCardapio] = DatabaseManager.sharedInstance.managedObjectContext?.executeFetchRequest(request, error: error) as! [ItemCardapio]
        
        return results
    }
    
}