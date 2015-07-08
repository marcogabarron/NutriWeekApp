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
    
//    var alimentosNomes = [String]()
//    var alimentosImages = [String]()
    
    var listaAlimentos = Array<AnyObject>()
    var listaOrdenada = Array<AnyObject>()
    
    
    func loadFeed () {
        
        let path = NSBundle.mainBundle().pathForResource("Alimentos", ofType: "txt")
        let jsonData = NSData(contentsOfFile: path!, options: .DataReadingMappedIfSafe, error: nil)
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
        
        var feed : NSArray = jsonResult["Alimentos"] as! NSArray
        
        
        for buildArray in feed {
            
            var alimento = Alimentos()
            alimento.setValue(buildArray.objectForKey("Nome"), forKeyPath: "nomeAlimento")
            alimento.setValue(buildArray.objectForKey("Imagem"), forKeyPath: "imagemAlimento")
            
            listaAlimentos.append(alimento)
        
        
        }
        
        //listaOrdenada = listaAlimentos.nomeAlimento.sorted() { ($0 as! String) < ($1 as! String) }

        println(listaOrdenada[0].name)
    }
    
}