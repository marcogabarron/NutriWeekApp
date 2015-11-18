//
//  Daily.swift
//  NutriWeekApp
//
//  Created by Jessica Oliveira on 12/11/15.
//  Copyright © 2015 Gabarron. All rights reserved.
//

import Foundation

class DailyModel: NSObject {
    var day: Daily?
    var indexPath: NSIndexPath
    
    /** create Meal **/
    init(day: Daily, index: NSIndexPath){
        self.day = day
        self.indexPath = index
    }
    
    override init() {
        indexPath = NSIndexPath(index: 99999)
    }
}
