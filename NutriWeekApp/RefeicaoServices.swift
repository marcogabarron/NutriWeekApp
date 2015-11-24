

import Foundation

class RefeicaoServices
{
    
    /** Create the Entity Refeicao that represent the Meal chosen for the user **/
    static func createRefeicao(name: String, horario: String, diaSemana: String, items: [ItemCardapio], uuid: String)
    {
        let refeicao: Refeicao = Refeicao()
        refeicao.name = name
        refeicao.horario = horario
        refeicao.diaSemana = diaSemana
        refeicao.uuid = uuid
        
        for item in items{
            refeicao.addItemsObject(item)
        }
        
        //Insert it
        RefeicaoDAO.insert(refeicao)
        
    }
    
    /** Edit datas from the Entity Refeicao - if different **/
    static func editRefeicao(refeicao: Refeicao, name: String, horario: String, diaSemana: String, items: [ItemCardapio])
    {
        RefeicaoServices.editRefeicao(refeicao, name: name, horario: horario, diaSemana: diaSemana, items: items, uuid: refeicao.uuid)
        
    }
    
    /** Edit datas from the Entity Refeicao - if different **/
    static func editRefeicao(refeicao: Refeicao, name: String, horario: String, diaSemana: String, items: [ItemCardapio], uuid: String)
    {
        if(refeicao.name != name){
            refeicao.name = name
        }
        if(refeicao.horario != horario){
            refeicao.horario = horario
        }
        if(refeicao.diaSemana != diaSemana){
            refeicao.diaSemana = diaSemana
        }
        
        for item in items{
            var find = false
            for itemFromRefeicao in refeicao.getItemsObject(){
                if(itemFromRefeicao == item){
                    find = true
                    break
                }
            }
            if(find == false){
                refeicao.addItemsObject(item)
            }
        }
        for itemFromRefeicao in refeicao.getItemsObject(){
            var find = false
            for item in items{
                if(itemFromRefeicao == item){
                    find = true
                    break
                }
            }
            if(find == false){
                refeicao.removeItemsObject(itemFromRefeicao)
            }
        }
        
        //Edit it and persist it
        RefeicaoDAO.edit(refeicao)
        
    }
    
    /** Delete Refeicao (Meal) By Uuid **/
    static func deleteRefeicaoByUuid(uuid: String)
    {
        ///Create queue
        let auxiliarQueue:NSOperationQueue = NSOperationQueue()
        
        ///Create operation
        let deleteOperation : NSBlockOperation = NSBlockOperation(block: {
            //Find ref
            let refeicao: Refeicao? = RefeicaoDAO.findByUuid(uuid)
            if (refeicao != nil)
            {
                // Delete ref
                RefeicaoDAO.delete(refeicao!)
            }
        })
        
        // Execute operation
        auxiliarQueue.addOperation(deleteOperation)
    }
    
    /** Delete Refeicao (Meal) By Uuid **/
    static func deleteMeal(meal: Refeicao)
    {
        // Create queue
        let auxiliarQueue:NSOperationQueue = NSOperationQueue()
        
        // Create operation
        let deleteOperation : NSBlockOperation = NSBlockOperation(block: {

                // Delete ref
                RefeicaoDAO.delete(meal)
        })
        
        // Execute operation
        auxiliarQueue.addOperation(deleteOperation)
    }
    
    /** Find all Meals with weekday passed **/
    static func findAll() -> [Refeicao]{
        return RefeicaoDAO.findAll()
    }
    
    /** Find all Meals with weekday passed **/
    static func findByWeek(str: String) -> [Refeicao]{
        return RefeicaoDAO.findByWeek(str)
    }
    
    /** Find one Meal with name passed **/
    static func findByName(str: String) -> Refeicao{
        return RefeicaoDAO.findByName(str)!
    }
    
    /** Verify if the name existed in any Meals **/
    static func findByNameBool(str: String) -> Bool{
        return RefeicaoDAO.findByNameBool(str)
    }
    
    /** Find one Meal with uuid passed **/
    static func findByUuid(str: String) -> Refeicao{
        return RefeicaoDAO.findByUuid(str)!
    }
    
    /** Find all Meals with name passed **/
    static func findAllWithSameName(str: String) -> [Refeicao]{
        return RefeicaoDAO.findAllWithSameName(str)
    }
    
}