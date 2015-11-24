//
//  AddItemVC.swift
//  NutriWeekApp
//
//  Created by Gabarron on 29/06/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.
//

import UIKit

class AddItemVC: UIViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate{
    
    //MARK: IBOutlets and other variables and constants
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var save: UIBarButtonItem!
    @IBOutlet weak var horario: UIDatePicker!
    ///Relative to Refeicao`s name
    @IBOutlet weak var nameTextField: UITextField!
    
    
    //Relative to models and CoreData
    var format = FormatDates()
    var meal: Meal = Meal(week: [], time: "", name: "")
    
    ///Manage meal frequency at week - init with all week days
    var mealWeekDays: Weeks = Weeks(selectedDays: ["Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado", "Domingo"])
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameTextField.placeholder = NSLocalizedString("Nome da Refeição", comment: "")
        self.nameTextField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        if(self.meal.foods.count >= 1){
            self.navigationController?.popViewControllerAnimated(true)

        }
        self.navigationItem.title = NSLocalizedString("Informações", comment: "")
        self.save.title = NSLocalizedString("Salvar", comment: "")

        self.tableView.reloadData()
    }
    
    
    //MARK: TableView
    
    //Table view used to go repeat Weekdays - just as occurs in the clock iOS
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("simpleCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = NSLocalizedString("Repetir", comment: "")
        
        if(self.mealWeekDays.getArrayString().count == 7){
            cell.detailTextLabel?.text = NSLocalizedString("Todos os dias", comment: "")
            
        } else {
            cell.detailTextLabel?.text = ""
            var buildDetail: String = " "
            
            //Write in the edited cell in weeks - part to make intuitive
            for day : String in self.mealWeekDays.getArrayString(){
                if(buildDetail != " "){
                    buildDetail = buildDetail.stringByAppendingString(", ")
                }
                
                switch day {
                case "Segunda":
                    buildDetail = buildDetail.stringByAppendingString(NSLocalizedString("seg", comment: ""))
                case "Terça":
                    buildDetail = buildDetail.stringByAppendingString(NSLocalizedString("ter", comment: ""))
                case "Quarta":
                    buildDetail = buildDetail.stringByAppendingString(NSLocalizedString("qua", comment: ""))
                case "Quinta":
                    buildDetail = buildDetail.stringByAppendingString(NSLocalizedString("qui", comment: ""))
                case "Sexta":
                    buildDetail = buildDetail.stringByAppendingString(NSLocalizedString("sex", comment: ""))
                case "Sábado":
                    buildDetail = buildDetail.stringByAppendingString(NSLocalizedString("sab", comment: ""))
                case "Domingo":
                    buildDetail = buildDetail.stringByAppendingString(NSLocalizedString("dom", comment: ""))
                default:
                    buildDetail = buildDetail.stringByAppendingString(NSLocalizedString("Nunca", comment: ""))
                }
            }
            cell.detailTextLabel?.text = buildDetail
        }
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell!.selected = false
    }

    
    //MARK: Actions
    
    /** Save action **/
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
                    
                } else {
                    self.performSegueWithIdentifier("Next", sender: self)
                }
            
        } else {
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
    }
    
    
    /** Close keyboard **/
    @IBAction func onTapped(sender: AnyObject) {
        view.endEditing(true)
    }

    @IBAction func UpdateTimerPicker(sender: AnyObject) {
        self.format.formatDateToString(self.horario.date)
    }
    
    
    //MARK: Logic Functions
    
    /** Close keyboard when clicked return **/
    func textFieldShouldReturn(nameTextField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
    
    
    //MARK - Prepare for segue
    
    /** Prepare for Segue to Week page -- pass the information from Weeks() **/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "Week") {
            let destinationViewController = segue.destinationViewController as! RepeatTVC
            destinationViewController.weekDays = self.mealWeekDays
            
        } else if (segue.identifier == "Next") {
                let destination = segue.destinationViewController as! SelectedFoodsVC
            
                self.meal.setDatas(self.mealWeekDays.getArrayString(), time: self.format.formatDateToString(self.horario.date), name: self.nameTextField.text!)
                destination.meal = meal
        }
        
    }
    
}
