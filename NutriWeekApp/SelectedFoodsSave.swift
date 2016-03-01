//
//  SelectedFoodsSave.swift
//  NutriWeekApp
//
//  Created by Jessica Oliveira on 23/10/15.
//  Copyright © 2015 Gabarron. All rights reserved.
//

import UIKit

class SelectedFoodsSave: SelectedFoodsVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.title = NSLocalizedString ("Concluir", comment: "")
    }
    
    //MARK: Actions
    
    /** Save action **/
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
            
        } else {
            
            self.meal.setItems(self.selectedItens)
            //Google Analytics - monitoring events - dicover created food
            tracker.send(GAIDictionaryBuilder.createEventWithCategory("Button Save", action: "To save meal. We want to see how many foods are in the register", label: nil, value: self.meal.foods.count).build() as [NSObject : AnyObject])
            
            for diaSemana in self.meal.dayOfWeek{
                
                // Add notification
                let dateFormat = NSDateFormatter()
                let todoItem = TodoItem(deadline: dateFormat.setNotificationDate(diaSemana, dateHour: self.meal.hour), title: self.meal.name, UUID: NSUUID().UUIDString)
                
                TodoList.sharedInstance.addItem(todoItem)
                
                //Add Refeicao
                RefeicaoServices.createRefeicao(self.meal.name, horario: self.meal.hour, diaSemana: diaSemana, items: self.selectedItens, uuid: todoItem.UUID)
            }
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
}
