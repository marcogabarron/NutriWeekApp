//
//  CollectionVC.swift
//  NutriWeekApp
//
//  Created by Gabarron on 03/07/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.


import UIKit

class CollectionVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var refeicao: UINavigationItem!
    @IBOutlet weak var editButton: UIBarButtonItem!

    @IBOutlet weak var notificationSwitch: UISwitch!

    @IBOutlet var tapGesture: UITapGestureRecognizer!
    var colorImage = UIColor.blackColor().CGColor
    
    
    //Relative to models and CoreData
    var itens = [ItemCardapio]()
    var selectedItens = [ItemCardapio]()
    var notification = Notifications()
    var dell: Bool = false
    
    ///Get the uuid of choosed Refeicao
    var meal: Meal!
    
    //Relative to collection View
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var hour: UIButton!
    @IBOutlet weak var bottomCV: NSLayoutConstraint!
    
    ///Relative to datePicker
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var saveClicked: Bool! = false
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
        if parent == nil && !saveClicked && self.editButton.enabled{
            
            //UIAlert para perguntar se ele deseja salvar somente para este dia ou para todos os dias
            let alert = UIAlertController(title: "Take one option",
                message: "Really want to go back?",
                preferredStyle: .Alert)
            
            let save = UIAlertAction(title: "Save modifications",
                style: .Default) { (action: UIAlertAction!) -> Void in
                    self.save()
            }
            
            let cancel = UIAlertAction(title: "Discard",
                style: .Default) { (action: UIAlertAction!) -> Void in
                    
            }
            presentViewController(alert,
                animated: true,
                completion: nil)
            
            
            alert.addAction(save)
            alert.addAction(cancel)
            
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.editButton.title = NSLocalizedString("", comment: "")
        self.refeicao.title = NSLocalizedString("Refeição", comment: "Editar")
        self.editButton.enabled = false
        self.itens = self.meal.foods
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {

        if(self.itens != self.meal.foods){
            //Get the Cardapio itens with the choosed Refeicao uuid
            self.itens = self.meal.foods
            self.editButton.title = NSLocalizedString("Salvar", comment: "Salvar")
            self.editButton.enabled = true

        }
        
        self.tapGesture.enabled = false
        
        //Get Refeicao`s name and time
        self.name.text = self.meal.name
        self.hour.setTitle(self.notification.formatStringTime(meal.hour), forState: .Normal)
        
        //allows multiple selections
        self.collectionView.allowsMultipleSelection = true
        
        self.collectionView.reloadData()
        
    }
    
    //MARK: CollectionView
    // show the items save in the Core Data
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itens.count+1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath) as! CollectionCell

        if(Int(indexPath.row) == self.itens.count){
            cell.textLabel.text = ""

            cell.image.image = UIImage(named: "add")
            cell.image.layer.masksToBounds = true
            cell.image.layer.cornerRadius = cell.frame.width/3
            
            cell.dellButton.hidden = true
            
        }else{
            cell.textLabel.text = itens[indexPath.row].name
            cell.textLabel.autoresizesSubviews = true
            
            cell.image.image = UIImage(named: "\(itens[indexPath.row].image)")
            cell.image.layer.masksToBounds = true
            cell.image.layer.cornerRadius = cell.frame.width/3
            
            if(dell == true){
                cell.dellButton.hidden = false
                cell.dellButton.addTarget(self, action: "deleteButton:", forControlEvents: UIControlEvents.TouchUpInside)
                self.shakeIcons(cell.layer)
                self.tapGesture.enabled = true
                
            }else{
                cell.dellButton.hidden = true

                let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressed:")
                cell.view.addGestureRecognizer(longPressRecognizer)
            }
        }
        
        cell.dellButton.layer.setValue(indexPath, forKey: "index")
        
        return cell
        
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == self.itens.count){
            self.performSegueWithIdentifier("Add", sender: self)
        }
        else if self.dell {
            let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath) as! CollectionCell
            
            self.dell = false
            
            self.stopShakingIcons(cell.layer)
        }
        else {
            self.performSegueWithIdentifier("ChangeFood", sender: indexPath)
        }
        
        self.collectionView.reloadData()
    }
    
    //MARK: Logic Functions

    //Checks whether the item is selected
    func isSelected(itemNew: ItemCardapio)->Bool{
        var boolean : Bool = false
        for item in self.selectedItens{
            if(itemNew == item){
                boolean = true
            }
        }
        return boolean
    }
    
    func longPressed(sender: UILongPressGestureRecognizer)
    {
        self.dell = true
        
        self.collectionView.reloadData()
        
    }
    
    func deleteButton(sender:UIButton) {
        
        let i : Int = (sender.layer.valueForKey("index")!.row) as Int
        self.meal.removeFood(i)
        
        self.dell = false
        
        self.itens = self.meal.foods
        
        self.editButton.title = NSLocalizedString("Salvar", comment: "Salvar")
        self.editButton.enabled = true
        
        var index: [NSIndexPath] = []
        index.append(sender.layer.valueForKey("index") as! NSIndexPath)
        
        self.collectionView.deleteItemsAtIndexPaths(index)
    }
    
    func shakeIcons(layer: CALayer) {
        let shakeAnim = CABasicAnimation(keyPath: "transform.rotation")
        shakeAnim.duration = 0.05
        shakeAnim.repeatCount = 2
        shakeAnim.autoreverses = true
        let startAngle: Float = (-2) * 3.14159/180
        let stopAngle = -startAngle
        shakeAnim.fromValue = NSNumber(float: startAngle)
        shakeAnim.toValue = NSNumber(float: 3 * stopAngle)
        shakeAnim.autoreverses = true
        shakeAnim.duration = 0.2
        shakeAnim.repeatCount = 10000
        shakeAnim.timeOffset = 290 * drand48()
        
        layer.addAnimation(shakeAnim, forKey:"shaking")
    }
    
    // This function stop shaking the collection view cells
    func stopShakingIcons(layer: CALayer) {
        layer.removeAnimationForKey("shaking")
    }
    
    @IBAction func save() {
        
        self.saveClicked = true
//        
//        let allRefWithSameName: [Refeicao] = RefeicaoServices.findAllWithSameName(self.meal.name)
//        var quantityVerify: Bool = false
//        
//        if allRefWithSameName.count > 1{
//            quantityVerify = true
//        }
//        
//        
//        //UIAlert para perguntar se ele deseja salvar somente para este dia ou para todos os dias
//        let alert = UIAlertController(title: "Take one option",
//            message: "This is a repeating event",
//            preferredStyle: .Alert)
//        
//                //Animation to show there are name already existing in the database
//                if(RefeicaoServices.findByNameBool(self.meal.name) == true){
//          
//                }else{
//                    
//                    let allDaysAction = UIAlertAction(title: "Save for all days",
//                        style: .Default) { (action: UIAlertAction!) -> Void in
//                            
//                            print("Salve para todos os dias")
//                            
//                            //Delete Refeicao and notification to each day because need to delete the notification and no add notification with same uuid
//                            //delete notifications that refer a meal
//                            for ref in allRefWithSameName{
//                                let date = NSDate()
//                                let todoItem = TodoItem(deadline: date, title: ref.name , UUID: ref.uuid )
//                                TodoList.sharedInstance.removeItem(todoItem)
//                                
//                                let notification = Notifications()
//                                let todoItem2 = TodoItem(deadline: notification.scheduleNotifications(ref.diaSemana, dateHour: self.meal.hour), title: self.meal.name, UUID: ref.uuid)
//                                TodoList.sharedInstance.addItem(todoItem2)
//                                
//                                RefeicaoServices.editRefeicao(ref, name: self.nameTextField.text!, horario: self.TimePicker(self.horario), diaSemana: ref.diaSemana, items: self.selectedItens)
//                                
//                            }
//                            self.navigationController?.popViewControllerAnimated(true)
//                            
//                    }
//                    
//                    let saveOnlyAction = UIAlertAction(title: "Save only the selected days",
//                        style: .Default) { (action: UIAlertAction!) -> Void in
//                            //It is delete and create notification - need to change
//                            let uid: String = self.refeicao.uuid
//                            
//                            let date = NSDate()
//                            let todoItem = TodoItem(deadline: date, title: self.refeicao.name , UUID: self.refeicao.uuid)
//                            TodoList.sharedInstance.removeItem(todoItem)
//                            
//                            let notification = Notifications()
//                            let todoItem2 = TodoItem(deadline: notification.scheduleNotifications(self.refeicao.diaSemana, dateHour: self.TimePicker(self.horario)), title: self.nameTextField.text!, UUID: uid)
//                            TodoList.sharedInstance.addItem(todoItem2)
//                            
//                            if(self.nameTextField.text! == self.refeicao.name){
//                                //edit MEAL name
//                                var number: Int = 1
//                                
//                                while( RefeicaoServices.findByNameBool(self.nameTextField.text! + String(number))){
//                                    number++
//                                }
//                                RefeicaoServices.editRefeicao(self.refeicao, name: self.nameTextField.text! + String(number), horario: self.TimePicker(self.horario), diaSemana: self.refeicao.diaSemana, items: self.selectedItens)
//                                
//                            }else{
//                                RefeicaoServices.editRefeicao(self.refeicao, name: self.nameTextField.text!, horario: self.TimePicker(self.horario), diaSemana: self.refeicao.diaSemana, items: self.selectedItens)
//                            }
//                            
//                            
//                            self.navigationController?.popViewControllerAnimated(true)
//                            
//                    }
//                    if quantityVerify == true {
//                        alert.addAction(allDaysAction)
//                        alert.addAction(saveOnlyAction)
//                    }else{
//                        //It is delete and create notification - need to change
//                        let uid: String = self.refeicao.uuid
//                        
//                        let date = NSDate()
//                        let todoItem = TodoItem(deadline: date, title: self.refeicao.name , UUID: self.refeicao.uuid)
//                        TodoList.sharedInstance.removeItem(todoItem)
//                        
//                        let notification = Notifications()
//                        let todoItem2 = TodoItem(deadline: notification.scheduleNotifications(self.refeicao.diaSemana, dateHour: self.TimePicker(self.horario)), title: self.nameTextField.text!, UUID: uid)
//                        TodoList.sharedInstance.addItem(todoItem2)
//                        
//                        //edit MEAL
//                        RefeicaoServices.editRefeicao(self.refeicao, name: self.nameTextField.text!, horario: self.TimePicker(self.horario), diaSemana: self.refeicao.diaSemana, items: self.selectedItens)
//                        
//                        self.navigationController?.popViewControllerAnimated(true)
//                        
//                    }
//                    
//                }
//            }
//        }else{
//        }
//        if quantityVerify == true {
//            presentViewController(alert,
//                animated: true,
//                completion: nil)
//        }
    }

    
    @IBAction func datePickerAppear(sender: AnyObject) {
        
        if(self.bottomCV.constant == 0){
            
            self.datePicker.date = self.formatTime((self.meal.hour))
            
            self.view.layoutIfNeeded()
            UIView.animateWithDuration(1, animations: {
                self.bottomCV.constant = self.view.frame.height*0.30
                self.view.layoutIfNeeded()
            })

        }else{
            self.view.layoutIfNeeded()
            UIView.animateWithDuration(1, animations: {
                self.bottomCV.constant = 0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func UpdateTimerPicker(sender: AnyObject) {
        self.editButton.title = NSLocalizedString("Salvar", comment: "Salvar")
        self.editButton.enabled = true

        self.meal.hour = timePicker(self.datePicker)
        self.hour.setTitle(self.notification.formatStringTime(meal.hour), forState: .Normal)

    }
    
    @IBAction func changeSwitch(sender: AnyObject) {
        self.editButton.title = NSLocalizedString("Salvar", comment: "Salvar")
        self.editButton.enabled = true
    }
    
    @IBAction func atopShaking(sender: AnyObject) {
        self.dell = false
        self.collectionView.reloadData()
    }
    /** Get datePicker and returns a string formatted to save Refeicao **/
    func timePicker(sender: UIDatePicker) -> String{
        
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
    
    @IBAction func switchNotificationChanged(){
        
        let notificationId: String = meal.id!
        
        if !notificationSwitch.on{
        let date = NSDate()
        let todoItem = TodoItem(deadline: date, title: self.meal.name , UUID: notificationId)
        TodoList.sharedInstance.removeItem(todoItem)
            
        }else {
            
            if notificationSwitch.on{
                
                let notification = Notifications()
                let todoItem = TodoItem(deadline: notification.scheduleNotifications(meal.dayOfWeek[0], dateHour: meal.hour), title: meal.name, UUID: notificationId)
                TodoList.sharedInstance.addItem(todoItem)
                
            }

        }
    }
    
    //MARK - Prepare for segue
    /** Prepare for Segue to Edit page -- pass the uuid information from cell clicked  **/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "Add") {
            let destinationViewController = segue.destinationViewController as! SelectedFoodsVC
            
            destinationViewController.meal = self.meal
        }
        else if (segue.identifier == "ChangeFood") {
            let destinationViewController = segue.destinationViewController as! ChangeFoodVC
            
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeFoodDismiss", name: "ChangeFoodDismiss", object: nil)
            
            destinationViewController.view.frame = CGRectInset(destinationViewController.view.frame, 100, 50);
            
            
            let indexPath = sender as! NSIndexPath
            let foodSelected = itens[indexPath.row]
            
            destinationViewController.itens = ItemCardapioServices.findItemCardapioByCategory(foodSelected.categoria)
            destinationViewController.selectedItemIndex = indexPath.row
            destinationViewController.meal = self.meal
        }
    }
    
    func changeFoodDismiss() {
        self.itens = self.meal.foods
        self.collectionView.reloadData()
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ChangeFoodDismiss", object: nil)
    }

}
