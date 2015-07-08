//
//  Alimentos.swift
//  NutriWeekApp
//
//  Created by Vítor Machado Rocha on 06/07/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.
//

import Foundation
import UIKit

class Alimentos {
    
//    var alimentosJson: Array<Array<String>> = []
    var alimentosJson = [String]()
    var alimentosImages = [String]()
    
    func loadFeed () {
        
        let path = NSBundle.mainBundle().pathForResource("Alimentos", ofType: "txt")
        let jsonData = NSData(contentsOfFile: path!, options: .DataReadingMappedIfSafe, error: nil)
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
        
//        var feed : NSDictionary = sorted (jsonResult) {  $0.0 as! String < $1.0 as! String }
        
        
        var feed : NSArray = jsonResult["Alimentos"] as! NSArray
        
        for buildArray in feed {
            var name = buildArray.objectForKey("Nome") as! String
            var image = buildArray.objectForKey("Imagem") as! String
            
            
//            alimentosJson.append([name, image])
            alimentosJson.append(name)
            alimentosImages.append(image)
            
//            var nElements = alimentosJson.count
//            
//            for fixedIndex in 0..<nElements {
//                for i in fixedIndex+1..<nElements {
//                    if alimentosJson[fixedIndex][0] > alimentosJson[i][0] {
//                        alimentosJson[fixedIndex] = alimentosJson[i]
//                        alimentosJson[i] = tmp
//                    }
//                }
//            }
        
        }

//        alimentosJson = alimentosJson.sorted(<)
//        alimentosImages = alimentosImages.sorted(<)
        
    }
    
}