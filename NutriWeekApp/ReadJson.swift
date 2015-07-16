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
    
    /** Read the JSON, create Alimentos objects with name and image. If is the first launch, pass these objects to Core Data**/
    func loadFeed () {
        
        ///Read JSON
        let path = NSBundle.mainBundle().pathForResource("Alimentos", ofType: "txt")
        let jsonData = NSData(contentsOfFile: path!, options: .DataReadingMappedIfSafe, error: nil)
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
        
        ///Array to build the objects
        var feed : NSArray = jsonResult["Alimentos"] as! NSArray
        
        ///Verify if is the first launch
        let firstLaunch = NSUserDefaults.standardUserDefaults().boolForKey("FirstLaunch")
        if firstLaunch  {
        }
        else {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "FirstLaunch")
            
            
            //Create Alimentos and pass to context
            for buildArray in feed {
                
                var alimento = Alimentos()
                alimento.setValue(buildArray.objectForKey("Nome"), forKeyPath: "nomeAlimento")
                alimento.setValue(buildArray.objectForKey("Imagem"), forKeyPath: "imagemAlimento")
                
                ItemCardapioServices.createItemCardapio(alimento.nomeAlimento, image: alimento.imagemAlimento)
                
            }
            
        }
        

    }
    
}