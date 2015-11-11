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
    ///array representative weeks
    var arrayString :[String]
    
    var change: Bool = false
    
    /** create Weeks with String array **/
    init(arrayString: [String]){
        self.arrayString = arrayString
        self.change = false
    }
    
    /** get the String Array **/
    func getArrayString() -> [String]{
        return self.arrayString
    }
    
    /** set with a new String Array **/
    func setArrayString(array: [String]){
        self.arrayString = array
        change = true
    }
    
    /** remove at index **/
    func removeAtIndex(index: Int){
        self.arrayString.removeAtIndex(index)
        change = true
    }
    
    /** add at index **/
    func append(str: String){
        self.arrayString.append(str)
        change = true
    }
    
    /** verify if the String (one day a week) there is in Array String **/
    func isSelected(str: String) -> Bool{
        var boolean : Bool = false
        for strings in self.arrayString {
            if(strings == str){
                boolean = true
            }
        }
        return boolean
    }
    
    func compareArray(week:[String]) -> Bool{
        for str in week {
            if(self.isSelected(str) == false){
                return false
            }
        }
        return true
    }
    
    func compareWeek(week:[String]) -> Bool{
        for str in self.arrayString {
            if(self.isSelected(str) == false){
                return false
            }
        }
        return true
    }
}
