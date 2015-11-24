//
//  SelectedFoodsVC.swift
//  NutriWeekApp
//
//  Created by Jessica Oliveira on 22/10/15.
//  Copyright © 2015 Gabarron. All rights reserved.
//

import UIKit
//colocar creteitemVC delegate se for o caso
class SelectedFoodsVC: UIViewController, UICollectionViewDataSource {

    ///Save Button
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    ///Relative to collection view
    @IBOutlet var collectionView: UICollectionView!
    
    ///Relative to search
    @IBOutlet weak var searchBar: UISearchBar!
    
    ///Relative to models and CoreData
    var itens = [ItemCardapio]()
    
    ///Array ItemCardapio with selected items
    var selectedItens = [ItemCardapio]()
    
    ///variable assist the search bar
    var searchActive: Bool = false
    
    ///Meal to edit
    var meal:Meal!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        saveButton.title = NSLocalizedString ("Salvar", comment: "")

    }
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title = NSLocalizedString("Seleção de Alimentos", comment: "Food")
        
        self.navigationController!.navigationBar.topItem!.title = NSLocalizedString("Cancelar", comment: "Cancel")
        
        //Show all itens, ascending by name
        self.itens = ItemCardapioServices.allItemCardapios()
        
        //initial empty serach bar text
        self.searchBar.text = ""
                
        self.collectionView.allowsMultipleSelection = true
        
        self.collectionView.reloadData()
    }
    
    //MARK: SearchBar
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchActive = true;
        //var barTintColor: UIColor
        self.searchBar.barTintColor = UIColor.darkGrayColor()
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchActive = false;
        self.searchBar.showsCancelButton = false
        self.searchBar.barTintColor = UIColor(red: 40/255, green: 150/255, blue: 120/255, alpha: 1)
        self.searchBar.resignFirstResponder()
        self.itens = ItemCardapioServices.allItemCardapios()
        searchBar.text = ""
        self.collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        //Active or inactive the search, depending of searchbar text
        if(searchBar.text == ""){
            self.searchActive = false;
            self.itens = ItemCardapioServices.allItemCardapios()
            
        } else {
            self.searchActive = true;
            self.itens = ItemCardapioServices.findItemCardapio(searchBar.text!, image: "\(searchBar.text)")
        }
        
        //find by category
        if(self.itens.count < 1){
            self.itens = ItemCardapioServices.findItemCardapioByCategory(searchBar.text!)
        }
        self.collectionView.reloadData()
    }
    
    //MARK: CollectionView
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itens.count+1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("SelectedCollectionViewCell", forIndexPath: indexPath) as! SelectedCollectionViewCell
        if(Int(indexPath.row) == self.itens.count){
            cell.textLabel.text = ""
            
            cell.image.image = UIImage(named: "Button")
            cell.image.layer.masksToBounds = true
            cell.image.layer.cornerRadius = cell.frame.width/3
        }else{
            cell.textLabel.text = itens[indexPath.row].name
            cell.textLabel.autoresizesSubviews = true
            
            cell.image.image = UIImage(named: "\(itens[indexPath.row].image)")
            cell.image.layer.masksToBounds = true
            cell.image.layer.cornerRadius = cell.frame.width/3
            
            //change the label color when it is already selected - It is within the selected array
            if(self.find(self.itens[indexPath.row])){
                cell.textLabel.textColor = UIColor(red: 40/255, green: 180/255, blue: 50/255, alpha: 1)
                cell.checkImage.hidden = false
                cell.checkImage.layer.masksToBounds = true
            }else{
                cell.textLabel.textColor = UIColor.blackColor()
                cell.checkImage.hidden = true
                cell.checkImage.layer.masksToBounds = true
            }
        }
        
        return cell
        
    }
    
    
    /** Select cell **/
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.row == self.itens.count){
            self.performSegueWithIdentifier("New", sender: self)
        }else{
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! SelectedCollectionViewCell
            //Selected: Change text to green
            
            
            //verify the collor text label because it is the way for verify if the object already selected
            if(cell.textLabel.textColor == UIColor(red: 40/255, green: 180/255, blue: 50/255, alpha: 1)){
                
                //go to deselected
                self.collectionView(self.collectionView, didDeselectItemAtIndexPath: indexPath)
                
            }else{
                
                cell.checkImage.hidden = false
                
                //Animation to grow and back to normal size when selected or deselected
                UIView.animateWithDuration(0.3, delay: 0.0, options: [], animations: {() -> Void in
                    
                    cell.transform = CGAffineTransformMakeScale(1.05, 1.05)
                    
                    }, completion: {(result) -> Void in
                        
                        UIView.animateWithDuration(0.3, animations: {() -> Void in
                            
                            cell.transform = CGAffineTransformMakeScale(1.0, 1.0)
                            
                        })
                        
                })
                
                
                
                cell.textLabel.textColor = UIColor(red: 40/255, green: 180/255, blue: 50/255, alpha: 1)
                
                //Set it is selected
                self.selectedItens.append(self.itens[indexPath.row])
            }
        

        }
    }
    
    /** DeSelect cell **/
    func collectionView(collectionView: UICollectionView,
        didDeselectItemAtIndexPath indexPath: NSIndexPath){
            
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! SelectedCollectionViewCell
            
            //verify the collor text label because it is the way for verify if the object already deselected
            if(cell.textLabel.textColor == UIColor.blackColor()){
                //go to selected
                self.collectionView(self.collectionView, didSelectItemAtIndexPath: indexPath)
            }else{
                cell.checkImage.hidden = true
                
                //Animation to grow and back to normal size when selected or deselected
                UIView.animateWithDuration(0.3, delay: 0.0, options: [], animations: {() -> Void in
                    
                    cell.transform = CGAffineTransformMakeScale(1.05, 1.05)
                    
                    }, completion: {(result) -> Void in
                        
                        UIView.animateWithDuration(0.3, animations: {() -> Void in
                            
                            cell.transform = CGAffineTransformMakeScale(1.0, 1.0)
                            
                        })
                        
                })
                
                
                //Deselect: Change text to black
                cell.textLabel.textColor = UIColor.blackColor()
                
                //Set it is desselected
                var index = 0
                for item in self.selectedItens{
                    if(self.itens[indexPath.row] == item){
                        self.selectedItens.removeAtIndex(index)
                    }
                    index++
                }
            }
            
    }
    
  
    /**Checks whether the item is selected**/
    func find(itemNew: ItemCardapio)->Bool{
        var boolean : Bool = false
        for item in self.selectedItens{
            if(itemNew == item){
                boolean = true
            }
        }
        return boolean
    }
    
}
