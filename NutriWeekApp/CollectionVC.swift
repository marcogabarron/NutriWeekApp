//
//  CollectionVC.swift
//  NutriWeekApp
//
//  Created by Gabarron on 03/07/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.


import UIKit

class CollectionVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {
    
    //important for translation
    @IBOutlet weak var refeicao: UINavigationItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var notificationSwitch: UISwitch!

    var colorImage = UIColor.blackColor().CGColor
    
    //datas saved before
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var hour: UIButton!
    
    //important for change when the date picker appear - animation
    @IBOutlet weak var bottomCV: NSLayoutConstraint!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    //Relative to models and CoreData
    var itens = [ItemCardapio]()
//    var selectedItens = [ItemCardapio]()
    var notification = Notifications()
    
    //Get the uuid of choosed Refeicao
    var meal: Meal!

    //booleans for logics
    var saveClicked: Bool! = false
    var dell: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //when there is nothing to change - not appear
        self.editButton.title = NSLocalizedString("", comment: "")
        self.editButton.enabled = false
        
        //translation
        self.refeicao.title = NSLocalizedString("Refeição", comment: "Editar")
        
        //items received foods of meal
        self.itens = self.meal.foods
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        
        self.navigationController!.navigationBar.topItem!.title = "Cancel"
        self.navigationItem.title = NSLocalizedString("Refeição", comment: "Editar")

        if(self.itens != self.meal.foods){
            //Get the Cardapio itens with the choosed Refeicao uuid
            self.itens = self.meal.foods
            self.editButton.title = NSLocalizedString("Salvar", comment: "Salvar")
            self.editButton.enabled = true
            
        }
        
        //Get Refeicao`s name and time
        self.name.text = self.meal.name
    
        //Get Time
        self.hour.setTitle(self.notification.formatStringTime(meal.hour), forState: .Normal)
        
        //allows multiple selections
        self.collectionView.allowsMultipleSelection = true
        
        
        //tap to stop shaking - if there are shaking
        let tap = UITapGestureRecognizer(target: self, action: "stopShaking:")
        tap.numberOfTapsRequired = 1
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        self.collectionView.reloadData()
        
        if (meal.id != ""){
        
        self.notificationSwitch.on = true
            
        }else{
            
            self.notificationSwitch.on = false
        }
    }
    
//    override func willMoveToParentViewController(parent: UIViewController?) {
//        super.willMoveToParentViewController(parent)
//        if parent == nil && !saveClicked && self.editButton.enabled{
//            
//            //UIAlert para perguntar se ele deseja salvar somente para este dia ou para todos os dias
//            let alert = UIAlertController(title: "Take one option",
//                message: "Really want to go back?",
//                preferredStyle: .Alert)
//            
//            let save = UIAlertAction(title: "Save modifications",
//                style: .Default) { (action: UIAlertAction!) -> Void in
//                    self.save()
//            }
//            
//            let cancel = UIAlertAction(title: "Discard",
//                style: .Default) { (action: UIAlertAction!) -> Void in
//                    
//            }
//            presentViewController(alert,
//                animated: true,
//                completion: nil)
//            
//            alert.addAction(save)
//            alert.addAction(cancel)
//        }
//    }
    
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
            self.dell = false
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
        for item in self.meal.foods{
            if(itemNew == item){
                boolean = true
            }
        }
        return boolean
    }
    
//    func longPressed(sender: UILongPressGestureRecognizer)
//    {
//        self.dell = true
//        
//        self.collectionView.reloadData()
//        
//    }
    
//    func deleteButton(sender:UIButton) {
//        
//        let i : Int = (sender.layer.valueForKey("index")!.row) as Int
//        self.meal.removeFood(i)
//        
//        self.dell = false
//        
//        self.itens = self.meal.foods
//        
//        self.editButton.title = NSLocalizedString("Salvar", comment: "Salvar")
//        self.editButton.enabled = true
//        
//        var index: [NSIndexPath] = []
//        index.append(sender.layer.valueForKey("index") as! NSIndexPath)
//        
//        self.collectionView.deleteItemsAtIndexPaths(index)
//    }
    
//    func shakeIcons(layer: CALayer) {
//        let shakeAnim = CABasicAnimation(keyPath: "transform.rotation")
//        shakeAnim.duration = 0.05
//        shakeAnim.repeatCount = 2
//        shakeAnim.autoreverses = true
//        let startAngle: Float = (-2) * 3.14159/180
//        let stopAngle = -startAngle
//        shakeAnim.fromValue = NSNumber(float: startAngle)
//        shakeAnim.toValue = NSNumber(float: 3 * stopAngle)
//        shakeAnim.autoreverses = true
//        shakeAnim.duration = 0.2
//        shakeAnim.repeatCount = 10000
//        shakeAnim.timeOffset = 290 * drand48()
//        
//        layer.addAnimation(shakeAnim, forKey:"shaking")
//    }
    
    // This function stop shaking the collection view cells
    func stopShakingIcons(layer: CALayer) {
        layer.removeAnimationForKey("shaking")
    }
    
    @IBAction func save(sender: AnyObject) {
        
        let allRefWithSameName: [Refeicao] = RefeicaoServices.findAllWithSameName(self.meal.name)
        var quantityVerify: Bool = false
        
        if allRefWithSameName.count > 1{
            quantityVerify = true
        }
        
        //UIAlert para perguntar se ele deseja salvar somente para este dia ou para todos os dias
        let alert = UIAlertController(title: "Take one option",
            message: "This is a repeating event",
            preferredStyle: .Alert)
                    
                    let allDaysAction = UIAlertAction(title: "Save for all days",
                        style: .Default) { (action: UIAlertAction!) -> Void in
                            
                            //Delete Refeicao and notification to each day because need to delete the notification and no add notification with same uuid
                            //delete notifications that refer a meal
                            for ref in allRefWithSameName{
                                let date = NSDate()
                                let todoItem = TodoItem(deadline: date, title: ref.name , UUID: ref.uuid )
                                TodoList.sharedInstance.removeItem(todoItem)
                                
                                //Switch notification off: remove uuid from meal
                                if !self.notificationSwitch.on {
                                    ref.uuid = ""
                                }
                                //Switch notification on and meal.id empty: genrate uuid
                                if  self.notificationSwitch.on {
                                    ref.uuid = NSUUID().UUIDString
                                    
                                    let notification = Notifications()
                                    let todoItem2 = TodoItem(deadline: notification.scheduleNotifications(ref.diaSemana, dateHour: self.meal.hour), title: self.meal.name, UUID: ref.uuid)
                                    TodoList.sharedInstance.addItem(todoItem2)
                                }
                                
                                
                                RefeicaoServices.editRefeicao(ref, name: self.meal.name, horario: self.meal.hour, diaSemana: ref.diaSemana, items: self.meal.foods, uuid: ref.uuid)
                                
                                
                            }
                            self.navigationController?.popViewControllerAnimated(true)
                            
                    }
        
                    let saveOnlyAction = UIAlertAction(title: "Save only the selected days",
                        style: .Default) { (action: UIAlertAction!) -> Void in
                            
                            let date = NSDate()
                            let todoItem = TodoItem(deadline: date, title: self.meal.name , UUID: self.meal.id!)
                            TodoList.sharedInstance.removeItem(todoItem)
                            
                            //Switch notification off: remove uuid from meal
                            if !self.notificationSwitch.on {
                                self.meal.id = ""
                            }
                            //Switch notification on and meal.id empty: genrate uuid
                            if  self.notificationSwitch.on {
                                self.meal.id = NSUUID().UUIDString
                                
                                let notification = Notifications()
                                let todoItem2 = TodoItem(deadline: notification.scheduleNotifications(self.meal.dayOfWeek[0], dateHour: self.meal.hour), title: self.meal.name, UUID: self.meal.id!)
                                TodoList.sharedInstance.addItem(todoItem2)
                            }
                            
                         
                            RefeicaoServices.editRefeicao(RefeicaoServices.findByName(self.meal.name), name: self.meal.name, horario: self.meal.hour, diaSemana: self.meal.dayOfWeek[0], items: self.meal.foods, uuid: self.meal.id!)
                            
                            self.navigationController?.popViewControllerAnimated(true)
                            }
        
                    if quantityVerify == true {
                        alert.addAction(allDaysAction)
                        alert.addAction(saveOnlyAction)
                    }else{
                        
                        let date = NSDate()
                        let todoItem = TodoItem(deadline: date, title: self.meal.name , UUID: self.meal.id!)
                        TodoList.sharedInstance.removeItem(todoItem)
                        
                        //Switch notification off: remove uuid from meal
                        if !self.notificationSwitch.on {
                            self.meal.id = ""
                        }
                        //Switch notification on and meal.id empty: genrate uuid
                        if  self.notificationSwitch.on {
                            self.meal.id = NSUUID().UUIDString
                            
                            let notification = Notifications()
                            let todoItem2 = TodoItem(deadline: notification.scheduleNotifications(self.meal.dayOfWeek[0], dateHour: self.meal.hour), title: self.meal.name, UUID: self.meal.id!)
                            TodoList.sharedInstance.addItem(todoItem2)
                        }
                        
                        //edit MEAL
                        RefeicaoServices.editRefeicao(RefeicaoServices.findByName(self.meal.name), name: self.meal.name, horario: self.meal.hour, diaSemana: self.meal.dayOfWeek[0], items: self.meal.foods, uuid: self.meal.id!)
                        
                        
                        
                        self.navigationController?.popViewControllerAnimated(true)
                        
                    }

        if quantityVerify == true {
            presentViewController(alert,
                animated: true,
                completion: nil)
        }
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
    
//    @IBAction func switchNotificationChanged(sender: AnyObject){
//        
//        let notificationId: String = meal.id!
//        let notificationSwitch = sender as! UISwitch
//        if !notificationSwitch.on{
//        let date = NSDate()
//        let todoItem = TodoItem(deadline: date, title: self.meal.name , UUID: notificationId)
//        TodoList.sharedInstance.removeItem(todoItem)
//            
//        }else {
//            
//            if notificationSwitch.on{
//                
//                let notification = Notifications()
//                let todoItem = TodoItem(deadline: notification.scheduleNotifications(meal.dayOfWeek[0], dateHour: meal.hour), title: meal.name, UUID: notificationId)
//                TodoList.sharedInstance.addItem(todoItem)
//                
//            }
//
//        }
//    }
    
    
    //MARK: Logic Functions
    
    //Checks whether the item is selected
//    func isSelected(itemNew: ItemCardapio)->Bool{
//        var boolean : Bool = false
//        for item in self.selectedItens{
//            if(itemNew == item){
//                boolean = true
//            }
//        }
//        return boolean
//    }
    
    func longPressed(sender: UILongPressGestureRecognizer)
    {
        if(self.dell == false){
            self.dell = true
            
            self.collectionView.reloadData()
        }
    }
    
    func stopShaking(gestureRecognizer: UITapGestureRecognizer){
        if(self.dell == true){
            self.dell = false
            self.collectionView.reloadData()
        }
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
        
        self.editButton.title = NSLocalizedString("Salvar", comment: "Salvar")
        self.editButton.enabled = true
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
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if(self.dell == false){
            return false

        }
        return true

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
