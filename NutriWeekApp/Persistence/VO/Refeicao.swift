

import Foundation
import CoreData

@objc(Refeicao)
class Refeicao: NSManagedObject
{
    @NSManaged var name: String
    @NSManaged var horario: String
    @NSManaged var diaSemana: String
    @NSManaged var cardapio: NSSet
    
    /// The designated initializer
    convenience init()
    {
        // get context
        let context:NSManagedObjectContext = DatabaseManager.sharedInstance.managedObjectContext!
        
        // create entity description
        let entityDescription:NSEntityDescription? = NSEntityDescription.entityForName("Refeicao", inManagedObjectContext: context)
        
        // call super using
        self.init(entity: entityDescription!, insertIntoManagedObjectContext: context)
    }

}
