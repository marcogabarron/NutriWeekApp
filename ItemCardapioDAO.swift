

import Foundation
import CoreData

class ItemCardapioDAO
{
    static func findAll() -> [ItemCardapio] {
        /// Creating fetch request
        let request = NSFetchRequest(entityName: "ItemCardapio")
        
        /// Sort Descriptor to ascending results by name
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
//        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true, comparator: .localizedCaseInsensitiveCompare(ItemCardapio))
        request.sortDescriptors = [sortDescriptor]
        
        // Perform search
        var error: NSErrorPointer = nil
        let results: [ItemCardapio] = DatabaseManager.sharedInstance.managedObjectContext?.executeFetchRequest(request, error: error) as! [ItemCardapio]
        return results
    }
    
    static func findByTime(horarioInicio: NSDate, horarioFim: NSDate) -> [ItemCardapio]
    {
        /// Creating fetch request
        let request = NSFetchRequest(entityName: "ItemCardapio")
        
        // Assign predicate
        request.predicate = NSPredicate(format: "horarioInicio <= %ld AND horarioFim <= %ld", horarioInicio, horarioFim)
        
        // assign sort descriptor
        //request.sortDescriptors = [NSSortDescriptor(key: "horarioInicio", ascending:true)]
        
        // Perform search
        var error: NSErrorPointer = nil
        let results: [ItemCardapio] = DatabaseManager.sharedInstance.managedObjectContext?.executeFetchRequest(request, error: error) as! [ItemCardapio]
        
        return results
    }
    
    //    static func findByNameAndDuration(name: String, duration: NSInteger) -> [Challenge]
    //    {
    //        // creating fetch request
    //        let request = NSFetchRequest(entityName: "Challenge")
    //
    //        // assign predicate
    //        request.predicate = NSPredicate(format: "name == %@ AND duration >= %ld", name, duration)
    //
    //        // assign sort descriptor
    //        request.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending:true)]
    //
    //        // perform search
    //        var error:NSErrorPointer = nil
    //        let results:[Challenge] = DatabaseManager.sharedInstance.managedObjectContext?.executeFetchRequest(request, error: error) as! [Challenge]
    //
    //        return results
    //    }
    
    static func findByName(name: String, image: String) -> [ItemCardapio]
    {
        /// Creating fetch request
        let request = NSFetchRequest(entityName: "ItemCardapio")
        
        // Assign predicate
        request.predicate = NSPredicate(format: "name CONTAINS[c] %@ AND image CONTAINS[c] %@", name, image)
        
        // Perform search
        var error: NSErrorPointer = nil
        let results: [ItemCardapio] = DatabaseManager.sharedInstance.managedObjectContext?.executeFetchRequest(request, error: error) as! [ItemCardapio]
        
        return results
    }
    
    
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
    
//    func localizedCaseInsensitiveCompare(string: String) -> NSComparisonResult {
//    
//    }
    
    
}