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
    ///Array representative weeks ///Array representing selected days to repeat meals in week
    var daysArray :[String]
    
    var change: Bool = false
    
    /** Create Weeks with String array **/
    init(selectedDays: [String]){
        self.daysArray = selectedDays
        self.change = false
    }
    
    /** Get the String Array **/
    func getArrayString() -> [String]{
        return self.daysArray
    }
    
    /** Set with a new String Array **/
    func setArrayString(selectedDays: [String]){
        self.daysArray = selectedDays
        change = true
    }
    
    /** Remove at index **/
    func removeDayAtIndex(index: Int){
        self.daysArray.removeAtIndex(index)
        change = true
    }
    
    /** Add day **/
    func appendDay(weekDay: String){
        self.daysArray.append(weekDay)
        change = true
    }
    
    /** Verify if the String (one day a week) there is in Array String **/
    func isSelected(weekDay: String) -> Bool{
        var boolean : Bool = false
        for strings in self.daysArray {
            if(strings == weekDay){
                boolean = true
            }
        }
        return boolean
    }
    
    func compareWeeks(week:[String]) -> Bool{
        for day in week {
            if(self.isSelected(day) == false){
                return false
            }
        }
        return true
    }
    
    func compareWeek(week:[String]) -> Bool{  //Não entendi porque pede week se não é usado
        for day in self.daysArray {
            if(self.isSelected(day) == false){
                return false
            }
        }
        return true
    }
}
