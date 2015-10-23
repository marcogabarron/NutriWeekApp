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
    var foods: [Food]
    
    /** create Meal **/
    init(week: [String], time: String, name: String, foods: [Food]){
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
    
}
