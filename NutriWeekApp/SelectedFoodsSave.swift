//
//  SelectedFoodsSave.swift
//  NutriWeekApp
//
//  Created by Jessica Oliveira on 23/10/15.
//  Copyright © 2015 Gabarron. All rights reserved.
//

import UIKit

class SelectedFoodsSave: SelectedFoodsVC {
    
    @IBOutlet weak var rememberCollectionView: UICollectionView!
    
    let collectionViewAIdentifier = "CollectionViewACell"
    let collectionViewBIdentifier = "SimpleCell"
    
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
    
    //MARK: CollectionView
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == self.rememberCollectionView){
            return self.selectedItens.count
        }
        return self.itens.count+1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
         if(collectionView == self.rememberCollectionView){
            let cell = self.rememberCollectionView.dequeueReusableCellWithReuseIdentifier(collectionViewBIdentifier, forIndexPath: indexPath) as! SimpleCell

            if(self.selectedItens.count > 0){
                cell.image.image = UIImage(named: "\(selectedItens[indexPath.row].image)")
                cell.image.layer.masksToBounds = true
                cell.image.layer.cornerRadius = cell.frame.width/5
                

            }
            return cell

            
        }else{
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

        }
        
    }
    
    /** Select cell **/
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
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
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath){
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

}
