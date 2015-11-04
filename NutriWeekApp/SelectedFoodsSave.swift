//
//  SelectedFoodsSave.swift
//  NutriWeekApp
//
//  Created by Jessica Oliveira on 23/10/15.
//  Copyright © 2015 Gabarron. All rights reserved.
//

import UIKit

class SelectedFoodsSave: SelectedFoodsVC {
    /**save action**/
    @IBAction func saveItemButton(sender: AnyObject) {
        if(self.selectedItens.count == 0){
            //Animation to show there are no selected food
            UIView.animateWithDuration(0.5, delay: 0.0, options: [], animations: {() -> Void in
                
                self.collectionView.backgroundColor = UIColor(red: 255/255, green: 200/255, blue: 255/255, alpha: 1)
                
                }, completion: {(result) -> Void in
                    
                    UIView.animateWithDuration(0.3, animations: {() -> Void in
                        
                        self.collectionView.backgroundColor = UIColor.whiteColor()
                        
                    })
                    
            })
            
            
        }else{
            self.meal.setItems(self.selectedItens)
            for diaSemana in self.meal.dayOfWeek{
                
                // Add notification
                let notification = Notifications()
                let todoItem = TodoItem(deadline: notification.scheduleNotifications(diaSemana, dateHour: self.meal.hour), title: self.meal.name, UUID: NSUUID().UUIDString)
                
                TodoList.sharedInstance.addItem(todoItem)
                
                //Add Refeicao
                RefeicaoServices.createRefeicao(self.meal.name, horario: self.meal.hour, diaSemana: diaSemana, items: self.selectedItens, uuid: todoItem.UUID)
                
            }
            
        }
        
        
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }

}
