

import Foundation

class ItemCardapioServices
{
    static func createItemCardapio(name: String, image: String)
    {
        
        var itemCardapio: ItemCardapio = ItemCardapio()
        itemCardapio.name = name
        itemCardapio.image = image

        
        // insert it
        ItemCardapioDAO.insert(itemCardapio)
        
    }
    
    static func findItemCardapio(name: String, image: String) -> [ItemCardapio]
    {
        // find it
        return ItemCardapioDAO.findByName(name, image: image)
        
    }
    
    static func allItemCardapios() -> [ItemCardapio] {
        return ItemCardapioDAO.findAll()
    }
    
}