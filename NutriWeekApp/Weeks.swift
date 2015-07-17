//
//  Week.swift
//  NutriWeekApp
//
//  Created by Jessica Oliveira on 07/07/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.
//

import Foundation
import UIKit

class Weeks {
    var arrayString :[String]
    
    init(arrayString: [String]){
        self.arrayString = arrayString
    }
    
    func convertToDate() /*-> [NSDate]*/{
        //implementação de converter a array de String para NSDate
    }
    
    func getArrayString() -> [String]{
        return self.arrayString
    }
    
    func setArrayString(array: [String]){
        self.arrayString = array
    }
    
    func removeAtIndex(index: Int){
        self.arrayString.removeAtIndex(index)
    }
    
    func append(str: String){
        self.arrayString.append(str)
    }
    
    func isSelected(str: String) -> Bool{
        var boolean : Bool = false
        for strings in self.arrayString {
            if(strings == str){
                boolean = true
            }
        }
        return boolean
    }
}
