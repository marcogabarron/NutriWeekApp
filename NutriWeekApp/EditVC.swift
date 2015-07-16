//
//  EditVC.swift
//  NutriWeekApp
//
//  Created by Jessica Oliveira on 15/07/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.
//

import UIKit

class EditVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    ///Relative to collection view
    @IBOutlet var collectionView: UICollectionView!
    
    //Relative to Refeicao`s name
    @IBOutlet weak var nameTextField: UITextField!
    
    //Relative to search
    @IBOutlet weak var searchBar: UISearchBar!
    var searchActive: Bool = false
    
    ///Relative to datePicker
    @IBOutlet weak var horario: UIDatePicker!
    
    //Relative to repeat/week
    @IBOutlet weak var tableView: UITableView!
    
    //Relative to models and CoreData
    var nutriVC = NutriVC()
    var itens = [ItemCardapio]()
    var selectedItens = [ItemCardapio]()
    var notification = Notifications()
    var daysOfWeekString: Weeks = Weeks(arrayString: [])
    var refeicao:Refeicao!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///Get all Refeicao`s with choosed name to edit
        var allRefWithSameName: [Refeicao] = RefeicaoServices.findAllWithSameName(self.refeicao.name)
        
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
        
        self.collectionView.reloadData()
        self.tableView.reloadData()
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
        
        if(self.find(self.itens[indexPath.row])){
            cell.textLabel.textColor = UIColor(red: 40/255, green: 180/255, blue: 50/255, alpha: 1)
            cell.click = true
            
        }else{
            cell.textLabel.textColor = UIColor.blackColor()
            cell.click = false
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
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as! SelectedCollectionViewCell
        
        //Animation to grow and back to normal size when selected or deselected
        UIView.animateWithDuration(0.3, delay: 0.0, options: nil, animations: {() -> Void in
            
            cell.transform = CGAffineTransformMakeScale(1.05, 1.05)
            
            }, completion: {(result) -> Void in
                
                UIView.animateWithDuration(0.3, animations: {() -> Void in
                    
                    cell.transform = CGAffineTransformMakeScale(1.0, 1.0)
                    
                })
                
        })
        
        //Selected: Change text to green
        if(cell.click == false){
            cell.image.layer.borderColor = UIColor(red: 40/255, green: 180/255, blue: 50/255, alpha: 1).CGColor
            cell.textLabel.textColor = UIColor(red: 40/255, green: 180/255, blue: 50/255, alpha: 1)
            
            //Set it is slected
            self.selectedItens.append(self.itens[indexPath.row])
            
        }else{
            
            cell.image.layer.borderColor = UIColor.blackColor().CGColor
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
        
        if(self.daysOfWeekString.getArrayString().count == 7){
            cell.detailTextLabel?.text = "Todos od Dias"
            
        }else{
            
            cell.detailTextLabel?.text = ""
            var text: String = " "
            
            // Write in the edited cell in weeks - part to make intuitive
            for str : String in self.daysOfWeekString.getArrayString(){
                if(text != " "){
                    text = text.stringByAppendingString(", ")
                }
                switch str {
                case "Segunda":
                    text = text.stringByAppendingString("seg")
                case "Terça":
                    text = text.stringByAppendingString("ter")
                case "Quarta":
                    text = text.stringByAppendingString("qua")
                case "Quinta":
                    text = text.stringByAppendingString("qui")
                case "Sexta":
                    text = text.stringByAppendingString("sex")
                case "Sábado":
                    text = text.stringByAppendingString("sab")
                case "Domingo":
                    text = text.stringByAppendingString("dom")
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
    
    @IBAction func saveItemButton(sender: AnyObject) {
        if(self.nameTextField.text != ""){
            
            //Animation to show there are no selected feed
            if(self.selectedItens.count == 0){
                UIView.animateWithDuration(0.5, delay: 0.0, options: nil, animations: {() -> Void in
                    
                    self.collectionView.backgroundColor = UIColor(red: 255/255, green: 200/255, blue: 255/255, alpha: 1)
                    
                    }, completion: {(result) -> Void in
                        
                        UIView.animateWithDuration(0.3, animations: {() -> Void in
                            
                            self.collectionView.backgroundColor = UIColor.whiteColor()
                            
                        })
                        
                })
                
                
            }else{
                
                //Delete Refeicao and notification to each day
                var allRefWithSameName: [Refeicao] = RefeicaoServices.findAllWithSameName(self.refeicao.name)
                var uid: String = self.refeicao.uuid
                var boolean = false
                for ref in allRefWithSameName{
                    RefeicaoServices.deleteRefeicaoByUuid(ref.uuid)
                    let date = NSDate()
                    let todoItem = TodoItem(deadline: date, title: ref.name , UUID: ref.uuid )
                    TodoList.sharedInstance.removeItem(todoItem)
                }
                
                //Save new Refeicao and notification to ecah day
                for diaSemana in self.daysOfWeekString.getArrayString(){
                    if(boolean == false){
                        let notification = Notifications()
                        let todoItem = TodoItem(deadline: notification.scheduleNotifications(diaSemana, dateHour: self.TimePicker(self.horario)), title: self.nameTextField.text, UUID: uid)
                        TodoList.sharedInstance.addItem(todoItem)
                        
                        RefeicaoServices.createRefeicao(self.nameTextField.text, horario: TimePicker(self.horario), diaSemana: diaSemana, items: self.selectedItens, uuid: uid)
                        
                        boolean = true
                        
                    }else{
                        
                        let notification = Notifications()
                        let todoItem = TodoItem(deadline: notification.scheduleNotifications(diaSemana, dateHour: self.TimePicker(self.horario)), title: self.nameTextField.text, UUID: NSUUID().UUIDString)
                        TodoList.sharedInstance.addItem(todoItem)
                        
                        RefeicaoServices.createRefeicao(self.nameTextField.text, horario: TimePicker(self.horario), diaSemana: diaSemana, items: self.selectedItens, uuid: todoItem.UUID)
                    }
                    
                }
                
            }
        }else{
            
            //Animation to save
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
    
    @IBAction func UpdateTimerPicker(sender: AnyObject) {
        
        TimePicker(self.horario)
        
    }
    
    //MARK: Logic Functions
    
    func TimePicker(sender: UIDatePicker) -> String{
        
        var timer = NSDateFormatter()
        
        timer.dateFormat = "HH:mm"
        
        var strdate = timer.stringFromDate(sender.date)
        
        return strdate
        
    }
    
    /** Convert stringDate to Date **/
    func formatTime(dataString: String) -> NSDate{
        
        var dateFormatter = NSDateFormatter()
        
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "WeekEdit") {
            let destinationViewController = segue.destinationViewController as! WeeksTableViewController
            destinationViewController.week = self.daysOfWeekString
        }else{

        }
    }
    
}

