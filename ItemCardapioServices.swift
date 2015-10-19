

import Foundation

class ItemCardapioServices
{
    /**create the Entity ItemCardapio that represent the Food**/
    static func createItemCardapio(name: String, image: String, category: String)
    {
        
        let itemCardapio: ItemCardapio = ItemCardapio()
        itemCardapio.name = name
        itemCardapio.image = image
        itemCardapio.categoria = category


        
        // insert it
        ItemCardapioDAO.insert(itemCardapio)
        
    }
    
    /** find one or more food with name(s) **/
    static func findItemCardapio(name: String, image: String) -> [ItemCardapio]
    {
        // find it
        return ItemCardapioDAO.findByName(name, image: image)
        
    }
    /** find one or more food with name(s) **/
    static func findItemCardapioByCategory(category: String) -> [ItemCardapio]
    {
        // find it
        return ItemCardapioDAO.findByCategory(category)
        
    }
    
    /** find all ItemCardapio **/
    static func allItemCardapios() -> [ItemCardapio] {
        return ItemCardapioDAO.findAll()
    }
    
}