

import Foundation

class ItemCardapioServices
{
    /** Create the Entity ItemCardapio that represent the Food **/
    static func createItemCardapio(name: String, image: String, category: String)
    {
        
        let itemCardapio: ItemCardapio = ItemCardapio()
        itemCardapio.name = name
        itemCardapio.image = image
        itemCardapio.categoria = category


        
        // Insert it
        ItemCardapioDAO.insert(itemCardapio)
        
    }
    
    /** Find one or more food with name(s) **/
    static func findItemCardapio(name: String, image: String) -> [ItemCardapio]
    {
        // Find it
        return ItemCardapioDAO.findByName(name, image: image)
        
    }
    /** Find one or more food with name(s) **/
    static func findItemCardapioByCategory(category: String) -> [ItemCardapio]
    {
        // Find it
        return ItemCardapioDAO.findByCategory(category)
        
    }
    
    /** Find all ItemCardapio **/
    static func allItemCardapios() -> [ItemCardapio] {
        return ItemCardapioDAO.findAll()
    }
    
}