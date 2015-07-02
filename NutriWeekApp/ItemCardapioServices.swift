

import Foundation

class ItemCardapioServices
{
    static func createItemCardapio(name: String)
    {
        var itemCardapio: ItemCardapio = ItemCardapio()
        itemCardapio.name = name
        
        // insert it
        ItemCardapioDAO.insert(itemCardapio)
    }
    
    static func deleteItemCardapioByName(name: String)
    {
        // create queue
        var auxiliarQueue:NSOperationQueue = NSOperationQueue()
        
        // create operation
        let deleteOperation : NSBlockOperation = NSBlockOperation(block: {
            // find challenge
            var itemCardapio: ItemCardapio? = ItemCardapioDAO.findByName(name)
            if (itemCardapio != nil)
            {
                // delete challenge
                ItemCardapioDAO.delete(itemCardapio!)
            }
        })
        
        // execute operation
        auxiliarQueue.addOperation(deleteOperation)
    }
    
    static func allItemCardapios() -> [ItemCardapio] {
        return ItemCardapioDAO.findAll()
    }
    
}