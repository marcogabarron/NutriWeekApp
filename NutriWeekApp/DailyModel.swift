//
//  Daily.swift
//  NutriWeekApp
//
//  Created by Jessica Oliveira on 12/11/15.
//  Copyright © 2015 Gabarron. All rights reserved.
//

import Foundation

class DailyModel: NSObject {
    var date: NSDate
    var fled: Bool
    var descriptionStr: String
    var nameImage: String?
    var hasImage: Bool?
    
    /** create Daily **/
    init(date: NSDate, fled: Bool, desc: String){
        self.date = date
        self.fled = fled
        self.descriptionStr = desc
        self.hasImage = false
        self.nameImage = ""

    }
    
    /** set Image **/
    func setImage(name: String){
        self.hasImage = true
        self.nameImage = name
    }
}
