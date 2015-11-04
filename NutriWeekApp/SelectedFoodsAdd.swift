//
//  SelectedFoodsAdd.swift
//  NutriWeekApp
//
//  Created by Jessica Oliveira on 23/10/15.
//  Copyright © 2015 Gabarron. All rights reserved.
//

import UIKit

class SelectedFoodsAdd: SelectedFoodsVC {
    
    override func viewWillAppear(animated: Bool) {
        //Show all itens, ascending by name
        self.itens = ItemCardapioServices.allItemCardapios()
        
        //initial empty serach bar text
        self.searchBar.text = ""
        
        self.collectionView.allowsMultipleSelection = true
        
        self.selectedItens = self.meal.foods
        
        self.collectionView.reloadData()
    }
    
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
            self.navigationController?.popViewControllerAnimated(true)
            
        }
    }

}
