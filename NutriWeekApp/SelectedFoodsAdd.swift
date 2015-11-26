//
//  SelectedFoodsAdd.swift
//  NutriWeekApp
//
//  Created by Jessica Oliveira on 23/10/15.
//  Copyright © 2015 Gabarron. All rights reserved.
//

import UIKit

class SelectedFoodsAdd: SelectedFoodsVC {
    
    //MARK: Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        
        //Google Analytics - monitoring screens
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Add Item in Edit diet")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        
        
        saveButton.title = NSLocalizedString ("", comment: "")
        saveButton.enabled = false

        //Show all itens, ascending by name
        self.itens = ItemCardapioServices.allItemCardapios()
        
        //Set empty initial serach bar text
        self.searchBar.text = ""
        
        self.selectedItens = self.meal.foods
                
        self.collectionView.allowsMultipleSelection = true
        self.collectionView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.meal.setItems(self.selectedItens)
        
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
            
            
        }else{
            self.meal.setItems(self.selectedItens)
            self.navigationController?.popViewControllerAnimated(true)
            
        }
    }

}
