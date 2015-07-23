

import Foundation
import CoreData

class RefeicaoDAO
{
    /** Insert element into context and Save context **/
    static func insert(objectToBeInserted: Refeicao)
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
    static func delete(objectToBeDeleted: Refeicao)
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

    /** creating fetch to find all meals **/
    static func findAll() -> [Refeicao] {
        // Creating fetch request
        let request = NSFetchRequest(entityName: "Refeicao")
        
        // Perform search
        var error: NSErrorPointer = nil
        let results = DatabaseManager.sharedInstance.managedObjectContext?.executeFetchRequest(request, error: error) as! [Refeicao]
        
        return results
    }
    
    /** find meal with same week used to predicate **/
    static func findByWeek(week: String) -> [Refeicao] {
        // Creating fetch request
        let request = NSFetchRequest(entityName: "Refeicao")
        
        // Put in date order
        let sortDescriptor = NSSortDescriptor(key: "horario", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        // Assign predicate
        request.predicate = NSPredicate(format: "diaSemana == %@", week)
        
        // Perform search
        var error: NSErrorPointer = nil
        let results: [Refeicao] = DatabaseManager.sharedInstance.managedObjectContext?.executeFetchRequest(request, error: error) as! [Refeicao]
        
        return results
    }
    
     /** find meal with same name used to predicate **/
    static func findAllWithSameName(name: String) -> [Refeicao]
    {
        // Creating fetch request
        let request = NSFetchRequest(entityName: "Refeicao")
        
        // Assign predicate
        request.predicate = NSPredicate(format: "name == %@", name)
        
        // Perform search
        var error: NSErrorPointer = nil
        let results: [Refeicao] = DatabaseManager.sharedInstance.managedObjectContext?.executeFetchRequest(request, error: error) as! [Refeicao]
        
        return results
    }
    
     /** find the last meal with same week used to predicate **/
    static func findByName(name: String) -> Refeicao?
    {
        // Creating fetch request
        let request = NSFetchRequest(entityName: "Refeicao")
        
        // Assign predicate
        request.predicate = NSPredicate(format: "name == %@", name)
        
        // Perform search
        var error: NSErrorPointer = nil
        let results: [Refeicao] = DatabaseManager.sharedInstance.managedObjectContext?.executeFetchRequest(request, error: error) as! [Refeicao]
        
        return results.last
    }
    
    /** find the first meal and return true or no find and return false **/
    static func findByNameBool(name: String) -> Bool
    {
        var refeicoes : [Refeicao] = self.findAll()
        var answer : Bool = false
        
        for ref in refeicoes{
            if(ref.name == name){
                answer = true
            }
        }
        
        
        return answer
    }
    
    /** find the last meal with uuid used to predicate **/
    static func findByUuid(uuid: String) -> Refeicao?
    {
        // Creating fetch request
        let request = NSFetchRequest(entityName: "Refeicao")
        
        // Assign predicate
        request.predicate = NSPredicate(format: "uuid == %@", uuid)
        
        // Perform search
        var error: NSErrorPointer = nil
        let results: [Refeicao] = DatabaseManager.sharedInstance.managedObjectContext?.executeFetchRequest(request, error: error) as! [Refeicao]
        
        return results.last
    }
    
}