//
//  SelectedFoodsVC.swift
//  NutriWeekApp
//
//  Created by Jessica Oliveira on 22/10/15.
//  Copyright © 2015 Gabarron. All rights reserved.
//

import UIKit

class SelectedFoodsVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate { //colocar creteitemVC delegate se for o caso

    //MARK: IBOutlets and other variables and constants
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var rememberCollectionView: UICollectionView!

    let collectionViewBIdentifier = "SimpleCell"
    
    ///Relative to models and CoreData
    var itens = [ItemCardapio]()
    var selectedItens = [ItemCardapio]()
    var meal: Meal!
    
    ///Search bar assistent. Say if it is active or no
    var searchActive: Bool = false
    
    //tracker - Google Analytics
    let tracker = GAI.sharedInstance().trackerWithTrackingId("UA-70701653-1")

    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        //Google Analytics - monitoring screens
        tracker.set(kGAIScreenName, value: "Selected Foods")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        
        
        self.navigationItem.title = NSLocalizedString("Seleção", comment: "Food")
        
        self.navigationController!.navigationBar.topItem!.title = NSLocalizedString("Cancelar", comment: "Cancel")
        
        //Set empty initial serach bar text
        self.searchBar.text = ""
        
        //Show all itens, ascending by name
        self.itens = ItemCardapioServices.allItemCardapios()
        
        self.collectionView.allowsMultipleSelection = true
        self.collectionView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    
    //MARK: SearchBar
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchActive = true;
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
        
        //Find by category
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
        if(collectionView == self.rememberCollectionView){
            return self.selectedItens.count
        }
        return self.itens.count+1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if(collectionView == self.collectionView){
            let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("SelectedCollectionViewCell", forIndexPath: indexPath) as! SelectedCollectionViewCell
            
            
            if(Int(indexPath.row) == self.itens.count){
                cell.textLabel.text = ""
                cell.image.image = UIImage(named: "addButton")
                
                cell.image.layer.masksToBounds = true
                cell.image.layer.cornerRadius = cell.frame.width/5
                
            } else {
                cell.textLabel.text = itens[indexPath.row].name
                cell.textLabel.autoresizesSubviews = true
                
                cell.image.image = UIImage(named: "\(itens[indexPath.row].image)")
                cell.image.layer.masksToBounds = true
                cell.image.layer.cornerRadius = cell.frame.width/5
                
                //Change label color when it is already selected - It is within the selected array
                if(self.find(self.itens[indexPath.row])){
                    cell.textLabel.textColor = UIColor(red: 40/255, green: 180/255, blue: 50/255, alpha: 1)
                    cell.checkImage.hidden = false
                    cell.checkImage.layer.masksToBounds = true
                    
                } else {
                    cell.textLabel.textColor = UIColor.blackColor()
                    cell.checkImage.hidden = true
                    cell.checkImage.layer.masksToBounds = true
                }
            }
            return cell
            
        }else{
        let cell = self.rememberCollectionView.dequeueReusableCellWithReuseIdentifier(collectionViewBIdentifier, forIndexPath: indexPath) as! SimpleCell
        
        if(self.selectedItens.count > 0){
            cell.image.image = UIImage(named: "\(selectedItens[indexPath.row].image)")
            cell.image.layer.masksToBounds = true
            cell.image.layer.cornerRadius = cell.frame.width/5
            
            
        }
        return cell
        }
    
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
            // Present the controller
            if UIDevice.currentDevice().userInterfaceIdiom != .Phone
            {
                if(collectionView == self.collectionView){
                    return CGSize(width: self.view.frame.width*0.23, height: self.view.frame.width*0.23 + 25)
                }else{
                    return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
                }
            }
            if(collectionView == self.collectionView){
                return CGSize(width: self.view.frame.width*0.3, height: self.view.frame.width*0.3 + 25)
            }else{
                return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
            }
    }
    
    /** Select cell **/
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if(collectionView == self.collectionView){
            if(indexPath.row == self.itens.count){
                self.performSegueWithIdentifier("New", sender: self)
                
            } else {
                let cell = collectionView.cellForItemAtIndexPath(indexPath) as! SelectedCollectionViewCell
                
                //Verify the collor text label because it is the way for verify if the object already selected
                if(cell.textLabel.textColor == UIColor(red: 40/255, green: 180/255, blue: 50/255, alpha: 1)){
                    
                    //Go to deselected
                    self.collectionView(self.collectionView, didDeselectItemAtIndexPath: indexPath)
                    
                } else {
                    
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
                    self.rememberCollectionView.reloadData()
                }
            }
        }
    }
    
    /** DeSelect cell **/
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath){
        if(collectionView == self.collectionView){
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! SelectedCollectionViewCell
            
            //Verify the collor text label because it is the way for verify if the object already deselected
            if(cell.textLabel.textColor == UIColor.blackColor()){
                
                //Go to selected
                self.collectionView(self.collectionView, didSelectItemAtIndexPath: indexPath)
                
            } else {
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
                self.rememberCollectionView.reloadData()
            }
        }
        
    }
  
    //MARK: Functions
    
    /** Checks whether the item is selected **/
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
