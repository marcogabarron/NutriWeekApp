

import Foundation
import CoreData

class RefeicaoDAO
{
    
    static func findAll() -> [Refeicao] {
        // creating fetch request
        let request = NSFetchRequest(entityName: "Refeicao")
        
        // perform search
        var error: NSErrorPointer = nil
        let results = DatabaseManager.sharedInstance.managedObjectContext?.executeFetchRequest(request, error: error) as! [Refeicao]
        
        return results
    }
    
    static func findByWeek(week: String) -> [Refeicao] {
        // creating fetch request
        let request = NSFetchRequest(entityName: "Refeicao")
        
        // assign predicate
        request.predicate = NSPredicate(format: "diaSemana == %@", week)
        
        // perform search
        var error: NSErrorPointer = nil
        let results: [Refeicao] = DatabaseManager.sharedInstance.managedObjectContext?.executeFetchRequest(request, error: error) as! [Refeicao]
        
        return results
    }
    
//
//    static func findByTime(horarioInicio: NSDate, horarioFim: NSDate) -> [ItemCardapio]
//        {
//            // creating fetch request
//            let request = NSFetchRequest(entityName: "ItemCardapio")
//    
//            // assign predicate
//            request.predicate = NSPredicate(format: "horarioInicio <= %ld AND horarioFim <= %ld", horarioInicio, horarioFim)
//            
//            // assign sort descriptor
//            //request.sortDescriptors = [NSSortDescriptor(key: "horarioInicio", ascending:true)]
//    
//            // perform search
//            var error: NSErrorPointer = nil
//            let results: [ItemCardapio] = DatabaseManager.sharedInstance.managedObjectContext?.executeFetchRequest(request, error: error) as! [ItemCardapio]
//    
//            return results
//        }
    
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
    
    static func findByName(name: String) -> Refeicao?
    {
        // creating fetch request
        let request = NSFetchRequest(entityName: "ItemCardapio")
        
        // assign predicate
        request.predicate = NSPredicate(format: "name == %@", name)
        
        // perform search
        var error: NSErrorPointer = nil
        let results: [Refeicao] = DatabaseManager.sharedInstance.managedObjectContext?.executeFetchRequest(request, error: error) as! [Refeicao]
        
        return results.last
    }
    
    
    static func insert(objectToBeInserted: Refeicao)
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
    
    static func delete(objectToBeDeleted: Refeicao)
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