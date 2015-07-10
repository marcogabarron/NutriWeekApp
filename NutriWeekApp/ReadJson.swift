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
    
    var listaAlimentos = Array<Alimentos>()
    var listaOrdenada = Array<Alimentos>()
    var i = 0
    
    func loadFeed () {
        
        let path = NSBundle.mainBundle().pathForResource("Alimentos", ofType: "txt")
        let jsonData = NSData(contentsOfFile: path!, options: .DataReadingMappedIfSafe, error: nil)
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
        
        var feed : NSArray = jsonResult["Alimentos"] as! NSArray
        
        let firstLaunch = NSUserDefaults.standardUserDefaults().boolForKey("FirstLaunch")
        if firstLaunch  {
            //println("Not first launch.")
        }
        else {
            //println("First launch, setting NSUserDefault.")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "FirstLaunch")
            
            for buildArray in feed {
                
                
                var alimento = Alimentos()
                alimento.setValue(buildArray.objectForKey("Nome"), forKeyPath: "nomeAlimento")
                alimento.setValue(buildArray.objectForKey("Imagem"), forKeyPath: "imagemAlimento")
                
                listaAlimentos.append(alimento)
                
                ItemCardapioServices.createItemCardapio(alimento.nomeAlimento, image: alimento.imagemAlimento)
                
            }
            
        }
        
  
    
        //listaOrdenada = listaAlimentos.nomeAlimento.sorted() { ($0 as! String) < ($1 as! String) }

//        println(listaAlimentos[0].nomeAlimento)
    }
    
}