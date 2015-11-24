//
//  Food.swift
//  NutriWeekApp
//
//  Created by Jessica Oliveira on 22/10/15.
//  Copyright © 2015 Gabarron. All rights reserved.
//

import Foundation

class Food: NSObject {
    
    var image: String!
    var name: String!
    var category: String!
    
    /** Read the JSON, create Alimentos objects with name and image. If is the first launch, pass these objects to Core Data**/
    func loadFeed () {
        
        ///Read JSON
        let nameDoc = NSLocalizedString("Alimentos", comment: "Alimento")
        let path = NSBundle.mainBundle().pathForResource(nameDoc, ofType: "txt")
        
        let jsonData: NSData?
        do {
            jsonData = try NSData(contentsOfFile: path!, options: .DataReadingMappedIfSafe)
        } catch {
            jsonData = nil
        }
        let jsonResult: NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
        
        ///Array to build the objects
        let foods : NSArray = jsonResult["Alimentos"] as! NSArray
        
        //Create Alimentos and pass to context
        for buildArray in foods {
            
            let food = Food()
            food.setValue(buildArray.objectForKey("Nome"), forKeyPath: "name")
            food.setValue(buildArray.objectForKey("Imagem"), forKeyPath: "image")
            food.setValue(buildArray.objectForKey("Category"), forKeyPath: "category")
            
            ItemCardapioServices.createItemCardapio(food.name, image: food.image, category: food.category)
        }
    }
    
}
