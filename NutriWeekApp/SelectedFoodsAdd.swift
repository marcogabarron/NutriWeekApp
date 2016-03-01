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
        tracker.set(kGAIScreenName, value: "Add Item in Edit diet")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        

        //Show all itens, ascending by name
        self.itens = ItemCardapioServices.allItemCardapios()
        
        //Set empty initial serach bar text
        self.searchBar.text = ""
        
        self.selectedItens = self.meal.foods
        
        self.collectionView.allowsMultipleSelection = true
        self.collectionView.reloadData()
        
        
        self.rememberCollectionView.reloadData()

        
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.meal.setItems(self.selectedItens)
        
    }

}
