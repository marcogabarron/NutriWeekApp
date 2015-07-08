

import Foundation

class RefeicaoServices
{
    static func createRefeicao(name: String, horario: String, diaSemana: String)
    {
        var refeicao: Refeicao = Refeicao()
        refeicao.name = name
        refeicao.horario = horario
        refeicao.diaSemana = diaSemana
        
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
    
    static func allItemRefeicao() -> [Refeicao] {
        return RefeicaoDAO.findAll()
    }
    
}