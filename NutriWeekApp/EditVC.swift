//
//  EditVC.swift
//  NutriWeekApp
//
//  Created by Jessica Oliveira on 15/07/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.
//

import UIKit

class EditVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    ///Save Button
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    ///Relative to collection view
    @IBOutlet var collectionView: UICollectionView!
    
    //Relative to Refeicao`s name
    @IBOutlet weak var nameTextField: UITextField!
    
    //Relative to search
    @IBOutlet weak var searchBar: UISearchBar!
    
    ///variable assist the search bar
    var searchActive: Bool = false
    
    ///Relative to datePicker
    @IBOutlet weak var horario: UIDatePicker!
    
    //Relative to repeat/week
    @IBOutlet weak var tableView: UITableView!
    
    //Relative to models and CoreData
    var nutriVC = NutriVC()
    
    ///Relative to models and CoreData
    var itens = [ItemCardapio]()
    
     ///Array ItemCardapio with selected items
    var selectedItens = [ItemCardapio]()
    
     ///Notification to edit
    var notification = Notifications()
    
    ///array Weeks with the week to edit
    var daysOfWeekString: Weeks = Weeks(arrayString: [])
    
    ///Meal to edit
    var refeicao:Refeicao!
    
    var i:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.title = NSLocalizedString("Salvar", comment: "Salvar")
        self.nameTextField.placeholder = NSLocalizedString("Nome da Refeição", comment: "Nome da Refeição")
        
        self.automaticallyAdjustsScrollViewInsets = false;
        
        //Get all Refeicao`s with choosed name to edit
        let allRefWithSameName: [Refeicao] = RefeicaoServices.findAllWithSameName(self.refeicao.name)
        
        //Add the array of setted days with this Refeicao
        var weeks: [String] = []
        for new in allRefWithSameName{
            weeks.append(new.diaSemana)
        }
        //Set array
        self.daysOfWeekString.setArrayString(weeks)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //Load all Cardapio itens
        self.itens = ItemCardapioServices.allItemCardapios()
        
        //Get informations of Refeicao
        self.getDatabaseInformation()
        
        //Set initial empty text field
        self.searchBar.text = ""
        
        self.collectionView.allowsMultipleSelection = true
        
        self.collectionView.reloadData()
//        self.tableView.reloadData()
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
        return self.itens.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("SelectedCollectionViewCell", forIndexPath: indexPath) as! SelectedCollectionViewCell
        
        
        cell.textLabel.text = NSLocalizedString(itens[indexPath.row].name!, comment: "")
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
    
    func find(itemNew: ItemCardapio)->Bool{
        var boolean : Bool = false
        for item in self.selectedItens{
            if(itemNew == item){
                boolean = true
            }
        }
        return boolean
    }
    
    
    /** Select cell **/
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! SelectedCollectionViewCell
        //Selected: Change text to green
        
        //verify the collor text label because it is the way for verify if the object already selected
        if(cell.textLabel.textColor == UIColor(red: 40/255, green: 180/255, blue: 50/255, alpha: 1)){
            //go to deselected
            self.collectionView(self.collectionView, didDeselectItemAtIndexPath: indexPath)
        }else{
            
            
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
    
    /** DeSelect cell **/
    func collectionView(collectionView: UICollectionView,
        didDeselectItemAtIndexPath indexPath: NSIndexPath){
            
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! SelectedCollectionViewCell
            
            //verify the collor text label because it is the way for verify if the object already deselected
            if(cell.textLabel.textColor == UIColor.blackColor()){
                //go to selected
                self.collectionView(self.collectionView, didSelectItemAtIndexPath: indexPath)
            }else{
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

    
    //MARK: actions
    
    @IBAction func saveItemButton(sender: AnyObject) {
        
        let allRefWithSameName: [Refeicao] = RefeicaoServices.findAllWithSameName(self.refeicao.name)
        var quantityVerify: Bool = false
        
        if allRefWithSameName.count > 1{
            quantityVerify = true
        }
        
        
        //UIAlert para perguntar se ele deseja salvar somente para este dia ou para todos os dias
        let alert = UIAlertController(title: "Take one option",
            message: "This is a repeating event",
            preferredStyle: .Alert)
        
        
        if(self.nameTextField.text != ""){
            
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
                //Animation to show there are name already existing in the database
                if(RefeicaoServices.findByNameBool(self.nameTextField.text!) == true && self.nameTextField.text != self.refeicao.name){
                    UIView.animateWithDuration(0.3, delay: 0.0, options: [], animations: {() -> Void in
                        
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

                    let allDaysAction = UIAlertAction(title: "Save for all days",
                        style: .Default) { (action: UIAlertAction!) -> Void in
                            
                            print("Salve para todos os dias")
                    
                            //Delete Refeicao and notification to each day because need to delete the notification and no add notification with same uuid                
                            //delete notifications that refer a meal
                            for ref in allRefWithSameName{
                                let date = NSDate()
                                let todoItem = TodoItem(deadline: date, title: ref.name , UUID: ref.uuid )
                                TodoList.sharedInstance.removeItem(todoItem)
                                
                                let notification = Notifications()
                                let todoItem2 = TodoItem(deadline: notification.scheduleNotifications(ref.diaSemana, dateHour: self.TimePicker(self.horario)), title: self.nameTextField.text!, UUID: ref.uuid)
                                TodoList.sharedInstance.addItem(todoItem2)
                                
                                RefeicaoServices.editRefeicao(ref, name: self.nameTextField.text!, horario: self.TimePicker(self.horario), diaSemana: ref.diaSemana, items: self.selectedItens)
                                
                            }
                                self.navigationController?.popViewControllerAnimated(true)

                    }
                    
                    let saveOnlyAction = UIAlertAction(title: "Save only the selected days",
                        style: .Default) { (action: UIAlertAction!) -> Void in
                            //It is delete and create notification - need to change
                            let uid: String = self.refeicao.uuid
                            
                            let date = NSDate()
                            let todoItem = TodoItem(deadline: date, title: self.refeicao.name , UUID: self.refeicao.uuid)
                            TodoList.sharedInstance.removeItem(todoItem)
                            
                            let notification = Notifications()
                            let todoItem2 = TodoItem(deadline: notification.scheduleNotifications(self.refeicao.diaSemana, dateHour: self.TimePicker(self.horario)), title: self.nameTextField.text!, UUID: uid)
                            TodoList.sharedInstance.addItem(todoItem2)
                            
                            if(self.nameTextField.text! == self.refeicao.name){
                                //edit MEAL name
                                var number: Int = 1
                                
                                while( RefeicaoServices.findByNameBool(self.nameTextField.text! + String(number))){
                                    number++
                                }
                                RefeicaoServices.editRefeicao(self.refeicao, name: self.nameTextField.text! + String(number), horario: self.TimePicker(self.horario), diaSemana: self.refeicao.diaSemana, items: self.selectedItens)
                                
                            }else{
                                RefeicaoServices.editRefeicao(self.refeicao, name: self.nameTextField.text!, horario: self.TimePicker(self.horario), diaSemana: self.refeicao.diaSemana, items: self.selectedItens)
                            }
                            
                            
                            self.navigationController?.popViewControllerAnimated(true)

                   }
                    if quantityVerify == true {
                        alert.addAction(allDaysAction)
                        alert.addAction(saveOnlyAction)
                    }else{
                        //It is delete and create notification - need to change
                        let uid: String = self.refeicao.uuid
                        
                        let date = NSDate()
                        let todoItem = TodoItem(deadline: date, title: self.refeicao.name , UUID: self.refeicao.uuid)
                        TodoList.sharedInstance.removeItem(todoItem)
                        
                        let notification = Notifications()
                        let todoItem2 = TodoItem(deadline: notification.scheduleNotifications(self.refeicao.diaSemana, dateHour: self.TimePicker(self.horario)), title: self.nameTextField.text!, UUID: uid)
                        TodoList.sharedInstance.addItem(todoItem2)
                        
                        //edit MEAL
                        RefeicaoServices.editRefeicao(self.refeicao, name: self.nameTextField.text!, horario: self.TimePicker(self.horario), diaSemana: self.refeicao.diaSemana, items: self.selectedItens)
                        
                        self.navigationController?.popViewControllerAnimated(true)
                        
                    }
                    
                }
                    }
            }else{
            
                //Animation to show there are no name food
                UIView.animateWithDuration(0.3, delay: 0.0, options: [], animations: {() -> Void in
                
                self.nameTextField.transform = CGAffineTransformMakeScale(1.2, 1.2)
                
                }, completion: {(result) -> Void in
                    
                    UIView.animateWithDuration(0.3, animations: {() -> Void in
                        
                        self.nameTextField.transform = CGAffineTransformMakeScale(1.0, 1.0)
                        self.nameTextField.backgroundColor = UIColor.whiteColor()
                        
                        
                    })
            })
        }
        if quantityVerify == true {
        presentViewController(alert,
            animated: true,
            completion: nil)
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
    /** read and transform DatePicker**/
    func TimePicker(sender: UIDatePicker) -> String{
        
        let timer = NSDateFormatter()
        
        timer.dateFormat = "HH:mm"
        
        let strdate = timer.stringFromDate(sender.date)
        
        return strdate
        
    }
    
    /** Convert stringDate to Date **/
    func formatTime(dataString: String) -> NSDate{
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        
        let dateValue = dateFormatter.dateFromString(dataString)
        
        return dateValue!
        
    }
    /** Get infomation of Refeicao`s **/
    func getDatabaseInformation(){
        self.selectedItens = refeicao.getItemsObject()
        self.nameTextField.text = refeicao.name
    
        self.horario.date = self.formatTime(self.refeicao.horario)
    }
    
    /**Close keyboard when clicked return **/
    func textFieldShouldReturn(nameTextField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
    
    //MARK - Prepare for segue
    /** Prepare for Segue to Week page -- pass the information from Weeks() **/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
}

