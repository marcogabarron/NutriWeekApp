//
//  AddItemVC.swift
//  NutriWeekApp
//
//  Created by Gabarron on 29/06/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.
//

import UIKit

class AddItemVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var nameTextField: UITextField!
    
    var nutriVC = NutriVC()
    
    var daysOfWeekString: Weeks = Weeks(arrayString: ["Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado", "Domingo"])
    
    var Array = [String]()
    var ArrayImages = [String]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        var alimentos = Alimentos()
        alimentos.loadFeed()
        Array = alimentos.alimentosJson.sorted(<)
        ArrayImages = alimentos.alimentosImages.sorted(<)
        
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    
    //MARK: CollectionView
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return Array.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SelectedCollectionViewCell", forIndexPath: indexPath) as! SelectedCollectionViewCell
        
        cell.textLabel.text = "\(Array[indexPath.row])"
        cell.textLabel.textColor = UIColor.blackColor()
        
        cell.image.image = UIImage(named: ArrayImages[indexPath.row])
        cell.image.layer.masksToBounds = true
        cell.image.layer.cornerRadius = cell.image.frame.width/3
        cell.layer.cornerRadius = cell.frame.width/4
        cell.image.layer.borderWidth = 2
        cell.image.layer.borderColor = UIColor.blackColor().CGColor
        
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as! SelectedCollectionViewCell
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: nil, animations: {() -> Void in
            
            cell.transform = CGAffineTransformMakeScale(1.05, 1.05)
            
            }, completion: {(result) -> Void in
                
                UIView.animateWithDuration(0.3, animations: {() -> Void in
                    
                    cell.transform = CGAffineTransformMakeScale(1.0, 1.0)
                    
                })
                
        })
        if(cell.click == false){
            cell.image.layer.borderColor = UIColor(red: 40/255, green: 180/255, blue: 50/255, alpha: 1).CGColor
            cell.textLabel.textColor = UIColor(red: 40/255, green: 180/255, blue: 50/255, alpha: 1)
            //Here is selected
            
        }else{
            cell.image.layer.borderColor = UIColor.blackColor().CGColor
            cell.textLabel.textColor = UIColor.blackColor()
             println(cell.textLabel)
            //Here is desselected
        }
        
        cell.click = !cell.click
    }
    @IBAction func test(sender: AnyObject) {
        println(sender.date)
    }
    
    //MARK: TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 1
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("simpleCell") as! UITableViewCell
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell!.selected = false
        
    }

    //MARK: actions
    
    @IBAction func saveItemButton(sender: AnyObject) {
        if(self.nameTextField.text != ""){
        ItemCardapioServices.createItemCardapio(self.nameTextField.text)
        nutriVC.items = ItemCardapioServices.allItemCardapios()
        self.nameTextField.text = ""
    }else{
        UIView.animateWithDuration(0.3, delay: 0.0, options: nil, animations: {() -> Void in
        
        self.nameTextField.transform = CGAffineTransformMakeScale(1.2, 1.2)
        
        }, completion: {(result) -> Void in
            
            UIView.animateWithDuration(0.3, animations: {() -> Void in
                
                self.nameTextField.transform = CGAffineTransformMakeScale(1.0, 1.0)
                self.nameTextField.backgroundColor = UIColor.whiteColor()
                
                
                })
        })
        }
    }
    
    @IBAction func onTapped(sender: AnyObject) {
        view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "Week") {
        let destinationViewController = segue.destinationViewController as! WeeksTableViewController
        destinationViewController.week = self.daysOfWeekString
        }
    }

}
