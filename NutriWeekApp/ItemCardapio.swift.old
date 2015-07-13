

import Foundation
import CoreData

@objc(ItemCardapio)
class ItemCardapio: NSManagedObject
{
    @NSManaged var name: String
    @NSManaged var horarioInicio: NSDate
    @NSManaged var horarioFim: NSDate
    @NSManaged var image: String
    @NSManaged var refeicao: NSSet
    
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