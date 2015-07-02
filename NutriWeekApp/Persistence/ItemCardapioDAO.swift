

import Foundation
import CoreData

class ItemCardapioDAO
{
    static func findAll() -> [ItemCardapio] {
        // creating fetch request
        let request = NSFetchRequest(entityName: "ItemCardapio")
        
        // perform search
        var error: NSErrorPointer = nil
        let results = DatabaseManager.sharedInstance.managedObjectContext?.executeFetchRequest(request, error: error) as! [ItemCardapio]
        
        return results
    }
    
    
//    static func findByNameAndDuration(name: String) -> [ItemCardapio]
//    {
//        // creating fetch request
//        let request = NSFetchRequest(entityName: "ItemCardapio")
//        
//        // assign predicate
//        request.predicate = NSPredicate(format: "name == %@", name)
//        
//        // perform search
//        var error: NSErrorPointer = nil
//        let results: [ItemCardapio] = DatabaseManager.sharedInstance.managedObjectContext?.executeFetchRequest(request, error: error) as! [ItemCardapio]
//        
//        return results
//    }
    
    static func findByName(name: String) -> ItemCardapio?
    {
        // creating fetch request
        let request = NSFetchRequest(entityName: "ItemCardapio")
        
        // assign predicate
        request.predicate = NSPredicate(format: "name == %@", name)
        
        // perform search
        var error: NSErrorPointer = nil
        let results: [ItemCardapio] = DatabaseManager.sharedInstance.managedObjectContext?.executeFetchRequest(request, error: error) as! [ItemCardapio]
        
        return results.last
    }
    
    
    static func insert(objectToBeInserted: ItemCardapio)
    {
        // insert element into context
        DatabaseManager.sharedInstance.managedObjectContext?.insertObject(objectToBeInserted)
        
        // save context
        var error: NSErrorPointer = nil
        DatabaseManager.sharedInstance.managedObjectContext?.save(error)
        if (error != nil)
        {
            // log error
            print(error)
        }
    }
    
    static func delete(objectToBeDeleted: ItemCardapio)
    {
        // remove object from context
        var error:NSErrorPointer = nil
        DatabaseManager.sharedInstance.managedObjectContext?.deleteObject(objectToBeDeleted)
        DatabaseManager.sharedInstance.managedObjectContext?.save(error)
        
        // log error
        if (error != nil)
        {
            // log error
            print(error)
        }
    }
    
    
    
}