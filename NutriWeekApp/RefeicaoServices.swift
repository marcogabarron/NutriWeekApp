

import Foundation

class RefeicaoServices
{
    
    /**create the Entity Refeicao that represent the Meal chosen for the user**/
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
        
        // insert it
        RefeicaoDAO.insert(refeicao)
        
    }
    
    /**edit datas from the Entity Refeicao - if different**/
    static func editRefeicao(refeicao: Refeicao, name: String, horario: String, diaSemana: String, items: [ItemCardapio])
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
        
        // edit it and persist it
        RefeicaoDAO.edit(refeicao)
        
    }
    
    /** delete Refeicao (Meal) By Uuid **/
    static func deleteRefeicaoByUuid(uuid: String)
    {
        // create queue
        let auxiliarQueue:NSOperationQueue = NSOperationQueue()
        
        // create operation
        let deleteOperation : NSBlockOperation = NSBlockOperation(block: {
            // find ref
            let refeicao: Refeicao? = RefeicaoDAO.findByUuid(uuid)
            if (refeicao != nil)
            {
                // delete ref
                RefeicaoDAO.delete(refeicao!)
            }
        })
        
        // execute operation
        auxiliarQueue.addOperation(deleteOperation)
    }
    
    /** find all Meals with weekday passed **/
    static func findByWeek(str: String) -> [Refeicao]{
        return RefeicaoDAO.findByWeek(str)
    }
    
    /** find one Meal with name passed **/
    static func findByName(str: String) -> Refeicao{
        return RefeicaoDAO.findByName(str)!
    }
    
    /** verify if the name existed in any Meals **/
    static func findByNameBool(str: String) -> Bool{
        return RefeicaoDAO.findByNameBool(str)
    }
    
    /** find one Meal with uuid passed **/
    static func findByUuid(str: String) -> Refeicao{
        return RefeicaoDAO.findByUuid(str)!
    }
    
    /** find all Meals with name passed **/
    static func findAllWithSameName(str: String) -> [Refeicao]{
        return RefeicaoDAO.findAllWithSameName(str)
    }
    
}