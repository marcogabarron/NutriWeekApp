//
//  Food.swift
//  NutriWeekApp
//
//  Created by Jessica Oliveira on 22/10/15.
//  Copyright © 2015 Gabarron. All rights reserved.
//

import Foundation
import UIKit

class Food: NSObject {
    var image: String
    var name: String?
    var category: String
    
    /** create Meal **/
    init(imageName: String, name: String, category: String){
        self.image = imageName
        self.name = name
        self.category = category
    }
    
}
