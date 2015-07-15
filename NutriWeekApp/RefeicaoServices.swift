

import Foundation

class RefeicaoServices
{
    static func createRefeicao(name: String, horario: String, diaSemana: String, items: [ItemCardapio], uuid: String)
    {
        var refeicao: Refeicao = Refeicao()
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
    
    static func deleteRefeicaoByName(name: String)
    {
        // create queue
        var auxiliarQueue:NSOperationQueue = NSOperationQueue()
        
        // create operation
        let deleteOperation : NSBlockOperation = NSBlockOperation(block: {
            // find challenge
            var refeicao: Refeicao? = RefeicaoDAO.findByName(name)
            if (refeicao != nil)
            {
                // delete challenge
                RefeicaoDAO.delete(refeicao!)
            }
        })
        
        // execute operation
        auxiliarQueue.addOperation(deleteOperation)
    }
    
    static func deleteRefeicaoByUuid(uuid: String)
    {
        // create queue
        var auxiliarQueue:NSOperationQueue = NSOperationQueue()
        
        // create operation
        let deleteOperation : NSBlockOperation = NSBlockOperation(block: {
            // find challenge
            var refeicao: Refeicao? = RefeicaoDAO.findByUuid(uuid)
            if (refeicao != nil)
            {
                // delete challenge
                RefeicaoDAO.delete(refeicao!)
            }
        })
        
        // execute operation
        auxiliarQueue.addOperation(deleteOperation)
    }
    
    static func allItemRefeicao() -> [Refeicao] {
        return RefeicaoDAO.findAll()
    }
    
    static func findByWeek(str: String) -> [Refeicao]{
        return RefeicaoDAO.findByWeek(str)
    }
    
    static func findByName(str: String) -> Refeicao{
        return RefeicaoDAO.findByName(str)!
    }
    
    static func findAllWithSameName(str: String) -> [Refeicao]{
        return RefeicaoDAO.findAllWithSameName(str)
    }
    
}