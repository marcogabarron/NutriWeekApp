//
//  Meal.swift
//  NutriWeekApp
//
//  Created by Jessica Oliveira on 22/10/15.
//  Copyright © 2015 Gabarron. All rights reserved.
//

import Foundation
import UIKit

class Meal: NSObject {
    
    var dayOfWeek: [String]
    var hour: String
    var name: String
    var foods: [ItemCardapio]
    var id: String?
    
    /** create Meal **/
    init(id: String, week: [String], time: String, name: String, foods: [ItemCardapio]){
        self.id = id
        self.dayOfWeek = week
        self.hour = time
        self.name = name
        self.foods = foods
    }
    
    /** create Meal **/
    init(week: [String], time: String, name: String){
        self.dayOfWeek = week
        self.hour = time
        self.name = name
        self.foods = []
    }
    
    func setItems(foods: [ItemCardapio]){
        self.foods = foods
    }
    
    func setDatas(week: [String], time: String, name: String){
        self.dayOfWeek = week
        self.hour = time
        self.name = name
        self.foods = []
    }
    
    func removeFood(n: Int){
        self.foods.removeAtIndex(n)
        print(self.foods)
    }

    
}
