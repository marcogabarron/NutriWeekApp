//
//  AddItemVC.swift
//  NutriWeekApp
//
//  Created by Gabarron on 29/06/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.
//

import UIKit

class AddItemVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITextFieldDelegate{
    
    ///Save Button
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    ///Relative to collection view
    @IBOutlet var collectionView: UICollectionView!
    
    ///Relative to Refeicao`s name
    @IBOutlet weak var nameTextField: UITextField!
    
    ///Relative to search
    @IBOutlet weak var searchBar: UISearchBar!
    
    ///variable assist the search bar
    var searchActive: Bool = false
    
    ///Relative to datePicker
    @IBOutlet weak var horario: UIDatePicker!
    
    ///Relative to repeat/week
    @IBOutlet weak var tableView: UITableView!
    
    ///Relative to models and CoreData
    var itens = [ItemCardapio]()
    
    ///Array ItemCardapio with selected items
    var selectedItens = [ItemCardapio]()
    
    ///array Weeks with the week - init with all
    var daysOfWeekString: Weeks = Weeks(arrayString: ["Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado", "Domingo"])
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.title = NSLocalizedString ("Salvar", comment: "")
        self.nameTextField.placeholder = NSLocalizedString("Nome da Refeição", comment: "")
        self.nameTextField.delegate = self;
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //Show all itens, ascending by name
        self.itens = ItemCardapioServices.allItemCardapios()
        
        //initial empty serach bar text
        self.searchBar.text = ""
        
        self.collectionView.allowsMultipleSelection = true
        
        self.collectionView.reloadData()
        self.tableView.reloadData()
    }
    
    //MARK: SearchBar
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchActive = true;
        var barTintColor: UIColor
        self.searchBar.barTintColor = UIColor.clearColor()
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
        
        
        cell.textLabel.text = NSLocalizedString(itens[indexPath.row].name, comment: "")
        cell.textLabel.autoresizesSubviews = true
        
        cell.image.image = UIImage(named:itens[indexPath.row].image)
        cell.image.layer.masksToBounds = true
        cell.image.layer.cornerRadius = cell.image.frame.width/3
        
        
        //change the label color when it is already selected - It is within the selected array
        if(self.find(self.itens[indexPath.row])){
            cell.textLabel.textColor = UIColor(red: 40/255, green: 180/255, blue: 50/255, alpha: 1)
        }else{
            cell.textLabel.textColor = UIColor.blackColor()
        }
        
        return cell
        
    }
    
    
    /** Select cell **/
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as! SelectedCollectionViewCell
        //Selected: Change text to green
        
        
        //verify the collor text label because it is the way for verify if the object already selected
        if(cell.textLabel.textColor == UIColor(red: 40/255, green: 180/255, blue: 50/255, alpha: 1)){
            //go to deselected
            self.collectionView(self.collectionView, didDeselectItemAtIndexPath: indexPath)
        }else{
            
            
            //Animation to grow and back to normal size when selected or deselected
            UIView.animateWithDuration(0.3, delay: 0.0, options: nil, animations: {() -> Void in
                
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
    
    /** DeSelect cell **/
    func collectionView(collectionView: UICollectionView,
        didDeselectItemAtIndexPath indexPath: NSIndexPath){
            
            var cell = collectionView.cellForItemAtIndexPath(indexPath) as! SelectedCollectionViewCell
            
            //verify the collor text label because it is the way for verify if the object already deselected
            if(cell.textLabel.textColor == UIColor.blackColor()){
                //go to selected
                self.collectionView(self.collectionView, didSelectItemAtIndexPath: indexPath)
            }else{
                //Animation to grow and back to normal size when selected or deselected
                UIView.animateWithDuration(0.3, delay: 0.0, options: nil, animations: {() -> Void in
                    
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

    
    //MARK: TableView
    //the table view is used to go repeat Weekdays - just as occurs in the clock iOS
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 1
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("simpleCell") as! UITableViewCell
        
        cell.textLabel?.text = NSLocalizedString("Repetir", comment: "")
        
        if(self.daysOfWeekString.getArrayString().count == 7){
            cell.detailTextLabel?.text = NSLocalizedString("Todos os dias", comment: "")
        }else{
            cell.detailTextLabel?.text = ""
            var text: String = " "
            
            //Write in the edited cell in weeks - part to make intuitive
            for str : String in self.daysOfWeekString.getArrayString(){
                if(text != " "){
                    text = text.stringByAppendingString(", ")
                }
                switch str {
                case "Segunda":
                    text = text.stringByAppendingString(NSLocalizedString("seg", comment: ""))
                case "Terça":
                    text = text.stringByAppendingString(NSLocalizedString("ter", comment: ""))
                case "Quarta":
                    text = text.stringByAppendingString(NSLocalizedString("qua", comment: ""))
                case "Quinta":
                    text = text.stringByAppendingString(NSLocalizedString("qui", comment: ""))
                case "Sexta":
                    text = text.stringByAppendingString(NSLocalizedString("sex", comment: ""))
                case "Sábado":
                    text = text.stringByAppendingString(NSLocalizedString("sab", comment: ""))
                case "Domingo":
                    text = text.stringByAppendingString(NSLocalizedString("dom", comment: ""))
                default:
                    text.stringByAppendingString("Nunca")
                }
            }
            cell.detailTextLabel?.text = text
        }
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell!.selected = false
        
    }

    //MARK: actions
    
    /**save action**/
    @IBAction func saveItemButton(sender: AnyObject) {
        if(self.nameTextField.text != ""){
            
            if(self.selectedItens.count == 0){
                //Animation to show there are no selected food
                UIView.animateWithDuration(0.5, delay: 0.0, options: nil, animations: {() -> Void in
                    
                    self.collectionView.backgroundColor = UIColor(red: 255/255, green: 200/255, blue: 255/255, alpha: 1)
                    
                    }, completion: {(result) -> Void in
                        
                        UIView.animateWithDuration(0.3, animations: {() -> Void in
                            
                            self.collectionView.backgroundColor = UIColor.whiteColor()
                            
                        })
                        
                })
                
            
            }else{
                //Animation to show there are name already existing in the database
                if(RefeicaoServices.findByNameBool(self.nameTextField.text) == true){
                    UIView.animateWithDuration(0.3, delay: 0.0, options: nil, animations: {() -> Void in
                        
                        self.nameTextField.transform = CGAffineTransformMakeScale(1.2, 1.2)
                        
                        }, completion: {(result) -> Void in
                            
                            UIView.animateWithDuration(0.3, animations: {() -> Void in
                                
                                self.nameTextField.transform = CGAffineTransformMakeScale(1.0, 1.0)
                                self.nameTextField.text = ""
                                self.nameTextField.placeholder = NSLocalizedString("*Use outro nome", comment: "")
                                self.nameTextField.tintColor = UIColor.redColor()
                                
                                
                            })
                    })
                }else{
                
                //Save Refeicao and notification
                for diaSemana in self.daysOfWeekString.getArrayString(){
                    
                    // Add notification
                    let notification = Notifications()
                    let todoItem = TodoItem(deadline: notification.scheduleNotifications(diaSemana, dateHour: self.TimePicker(self.horario)), title: self.nameTextField.text, UUID: NSUUID().UUIDString)
                    TodoList.sharedInstance.addItem(todoItem)
                    print(diaSemana)
                    
                    //Add Refeicao
                    RefeicaoServices.createRefeicao(self.nameTextField.text, horario: TimePicker(self.horario), diaSemana: diaSemana, items: self.selectedItens, uuid: todoItem.UUID)
                    
                }
                self.nameTextField.text = ""
                    
                
                }
            }
        }else{
            //Animation to show there are no name food
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
    
    
    /**Close keyboard**/
    @IBAction func onTapped(sender: AnyObject) {
        view.endEditing(true)
    }

    @IBAction func UpdateTimerPicker(sender: AnyObject) {
        TimePicker(self.horario)
        
    }
    
    
    //MARK: Logic Functions
    
    /** Get datePicker and returns a string formatted to save Refeicao **/
    func TimePicker(sender: UIDatePicker) -> String{
        
        var timer = NSDateFormatter()
        timer.dateFormat = "HH:mm"
        
        var strdate = timer.stringFromDate(sender.date)
        
        return strdate
        
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
    
    /**Close keyboard when clicked return **/
    func textFieldShouldReturn(nameTextField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
    
    //MARK - Prepare for segue
    /** Prepare for Segue to Week page -- pass the information from Weeks() **/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "Week") {
            let destinationViewController = segue.destinationViewController as! WeeksTVC
            destinationViewController.week = self.daysOfWeekString
        }else{
            
        }
    }
    
}
