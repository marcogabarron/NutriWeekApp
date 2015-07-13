//
//  Alimentos.swift
//  NutriWeekApp
//
//  Created by Vítor Machado Rocha on 06/07/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.
//

import Foundation
import UIKit

class ReadJson {
    
    
//    var listaAlimentos = Array<Alimentos>()
    
    /** Método para leitura do JSON, criando objetos(Alimentos) com nome e imagem. No caso de ser a primeira vez que o app abre, esses objetos são passados para o coreData **/
    func loadFeed () {
        
        //Leitura do JSON
        let path = NSBundle.mainBundle().pathForResource("Alimentos", ofType: "txt")
        let jsonData = NSData(contentsOfFile: path!, options: .DataReadingMappedIfSafe, error: nil)
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
        
        ///Array que permite a construção do objeto
        var feed : NSArray = jsonResult["Alimentos"] as! NSArray
        
        ///Verifica se é a primeira vez
        let firstLaunch = NSUserDefaults.standardUserDefaults().boolForKey("FirstLaunch")
        if firstLaunch  {
        }
        else {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "FirstLaunch")
            
            
            //Gera os Alimentos e passa para o contexto.
            for buildArray in feed {
                
                var alimento = Alimentos()
                alimento.setValue(buildArray.objectForKey("Nome"), forKeyPath: "nomeAlimento")
                alimento.setValue(buildArray.objectForKey("Imagem"), forKeyPath: "imagemAlimento")
                
//                listaAlimentos.append(alimento)
                
                ItemCardapioServices.createItemCardapio(alimento.nomeAlimento, image: alimento.imagemAlimento)
                
            }
            
        }
        

    }
    
}