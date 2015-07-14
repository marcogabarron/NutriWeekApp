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
    @IBOutlet weak var horario: UIDatePicker!
    @IBOutlet weak var searchBar: UISearchBar!
    

    var nutriVC = NutriVC()
    var itens = [ItemCardapio]()
    var selectedItens = [ItemCardapio]()
    
    var daysOfWeekString: Weeks = Weeks(arrayString: ["Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado", "Domingo"])
    
    var searchActive: Bool = false

        
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.itens = ItemCardapioServices.allItemCardapios()
        self.searchBar.text = ""
        self.collectionView.reloadData()

    }
    
    //MARK: SearchBar
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        

        if(searchBar.text == ""){
            self.searchActive = false;
            self.itens = ItemCardapioServices.allItemCardapios()
//            let items = ItemCardapioServices.allItemCardapios()
//            self.itens.removeAll(keepCapacity: false)
//            for item in items {
//                self.itens.append(item)
//            }
            
        } else {
            self.searchActive = true;
            self.itens = ItemCardapioServices.findItemCardapio(searchBar.text, image: "\(searchBar.text)")
        }
        self.collectionView.reloadData()
    }
    
    //MARK: CollectionView
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return self.itens.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("SelectedCollectionViewCell", forIndexPath: indexPath) as! SelectedCollectionViewCell
        
        
        cell.textLabel.text = itens[indexPath.row].name
        cell.textLabel.textColor = UIColor.blackColor()
        
        cell.image.image = UIImage(named:itens[indexPath.row].image)
        cell.image.layer.masksToBounds = true
        cell.image.layer.cornerRadius = cell.image.frame.width/3
//        cell.image.layer.borderWidth = 2
//        cell.image.layer.borderColor = UIColor.blackColor().CGColor
//        
//        cell.layer.cornerRadius = cell.frame.width/4
        
        if(self.find(self.itens[indexPath.row])){
//            cell.image.layer.borderColor = UIColor(red: 40/255, green: 180/255, blue: 50/255, alpha: 1).CGColor
            cell.textLabel.textColor = UIColor(red: 40/255, green: 180/255, blue: 50/255, alpha: 1)
            cell.click = true

        }else{
//            cell.image.layer.borderColor = UIColor.blackColor().CGColor
            cell.textLabel.textColor = UIColor.blackColor()
            cell.click = false
        }
        
        return cell
        
    }
    
    func find(itemNew: ItemCardapio)->Bool{
        var re : Bool = false
        for item in self.selectedItens{
            if(itemNew == item){
                re = true
            }
        }
        return re
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
            self.selectedItens.append(self.itens[indexPath.row])
        }else{
            cell.image.layer.borderColor = UIColor.blackColor().CGColor
            cell.textLabel.textColor = UIColor.blackColor()
            //Here is desselected
            var i = 0
            for item in self.selectedItens{
                if(self.itens[indexPath.row] == item){
                    self.selectedItens.removeAtIndex(i)
                }
                i++
            }
        }
                
        cell.click = !cell.click
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
            var i = 0
            if(self.selectedItens.count == 0){
                UIView.animateWithDuration(0.5, delay: 0.0, options: nil, animations: {() -> Void in
                    
                    self.collectionView.backgroundColor = UIColor(red: 255/255, green: 200/255, blue: 255/255, alpha: 1)
                    
                    }, completion: {(result) -> Void in
                        
                        UIView.animateWithDuration(0.3, animations: {() -> Void in
                            
                            self.collectionView.backgroundColor = UIColor.whiteColor()
                            
                        })
                        
                })
                
            
            }else{
                //save here
                for diaSemana in self.daysOfWeekString.getArrayString(){
                    
                    let notification = Notifications()
                    let todoItem = TodoItem(deadline: notification.listNotifications(diaSemana, dateHour: self.TimePicker(self.horario)), title: "Teste", UUID: NSUUID().UUIDString)
                    TodoList.sharedInstance.addItem(todoItem)
                    
                    RefeicaoServices.createRefeicao(self.nameTextField.text, horario: TimePicker(self.horario), diaSemana: diaSemana, items: self.selectedItens, uuid: todoItem.UUID)
                }
                
                

                self.nameTextField.text = ""
            }
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

    
    func TimePicker(sender: UIDatePicker) -> String{
        
        var timer = NSDateFormatter()
        
        timer.dateFormat = "HH:mm:ss"
        
        var strdate = timer.stringFromDate(sender.date)
        
        return strdate
        
    }
    
    @IBAction func UpdateTimerPicker(sender: AnyObject) {
        
        TimePicker(self.horario)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "Week") {
            let destinationViewController = segue.destinationViewController as! WeeksTableViewController
            destinationViewController.week = self.daysOfWeekString
        }else{
            
        }
    }
    
}
