//
//  AddItemVC.swift
//  NutriWeekApp
//
//  Created by Gabarron on 29/06/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.
//

import UIKit

class AddItemVC: UIViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate{
    
    ///Relative to Refeicao`s name
    @IBOutlet weak var nameTextField: UITextField!
    
    ///Relative to datePicker
    @IBOutlet weak var horario: UIDatePicker!
    
    ///Relative to repeat/week
    @IBOutlet weak var tableView: UITableView!
    
    ///array Weeks with the week - init with all
    var daysOfWeekString: Weeks = Weeks(arrayString: ["Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado", "Domingo"])
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameTextField.placeholder = NSLocalizedString("Nome da Refeição", comment: "")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.tableView.reloadData()
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("simpleCell", forIndexPath: indexPath)
        
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
                    text = text.stringByAppendingString(NSLocalizedString("Nunca", comment: ""))
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
            
            
                //Animation to show there are name already existing in the database
                if(RefeicaoServices.findByNameBool(self.nameTextField.text!) == true){
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
            self.performSegueWithIdentifier("Next", sender: self)

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
        
//        self.navigationController?.popViewControllerAnimated(true)
        
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
        
        let timer = NSDateFormatter()
        timer.dateFormat = "HH:mm"
        
        let strdate = timer.stringFromDate(sender.date)
        
        return strdate
        
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
            if (segue.identifier == "Next") {
                let destination = segue.destinationViewController as! SelectedFoodsVC
                var meal: Meal
                meal = Meal(week: self.daysOfWeekString.getArrayString(), time: self.TimePicker(self.horario), name: self.nameTextField.text!)
                destination.meal = meal
            }
        }
    }
    
}
