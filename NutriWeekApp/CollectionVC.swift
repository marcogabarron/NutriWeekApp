//
//  CollectionVC.swift
//  NutriWeekApp
//
//  Created by Gabarron on 03/07/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.


import UIKit

class CollectionVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {
    
    //important for translation
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var notificationLabel: UILabel!

    var colorImage = UIColor.blackColor().CGColor
    
    //datas saved before
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var hour: UIButton!
    
    //important for change when the date picker appear - animation
    @IBOutlet weak var bottomCV: NSLayoutConstraint!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var daysOfWeekString: Weeks = Weeks(arrayString: ["Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado", "Domingo"])
    
    //Relative to models and CoreData
    var itens = [ItemCardapio]()
    var notification = Notifications()
    
    //Get the uuid of choosed Refeicao
    var meal: Meal!

    var dell: Bool = false
    
    let transitionManager = TransitionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //when there is nothing to change - not appear
        self.editButton.title = NSLocalizedString("", comment: "")
        self.editButton.enabled = false
        
        //items received foods of meal
        self.itens = self.meal.foods
        let w: Weeks = Weeks(arrayString: [])

        let mealsWithSameName: [Refeicao] = RefeicaoServices.findAllWithSameName(self.meal.name)
        for m in mealsWithSameName {
            w.append(m.diaSemana)
        }
        self.daysOfWeekString = w
        self.daysOfWeekString.change = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        
        self.navigationItem.title = NSLocalizedString("Refeição", comment: "Refeição")
        self.notificationLabel.text = NSLocalizedString("Notificação", comment: "Notification")

        if(self.itens != self.meal.foods){
            //Get the Cardapio itens with the choosed Refeicao uuid
            self.itens = self.meal.foods
            self.modeSave()
            
        }
        
        if(self.daysOfWeekString.change){
            self.modeSave()
        }
        
        //Get Refeicao`s name and time
        self.navigationItem.title = self.meal.name
    
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
        
        self.tableView.reloadData()
    }
    
    //MARK: CollectionView
    // show the items save in the Core Data
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itens.count+1
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
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
    
    func collectionView(collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
            //1
            switch kind {
                //2
            case UICollectionElementKindSectionHeader:
                //3
                let headerViewLabel =
                collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                    withReuseIdentifier: "headerView",
                    forIndexPath: indexPath)
                    as! CollectionDiaryClass
                headerViewLabel.headerViewLabel.text = "Planejamenti"
                return headerViewLabel
            default:
                //4
                assert(false, "Unexpected element kind")
            }
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
                case "Domingo":
                    text = text.stringByAppendingString(NSLocalizedString("dom", comment: ""))
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

    //MARK: Actions

    @IBAction func save(sender: AnyObject) {
        
        let allRefWithSameName: [Refeicao] = RefeicaoServices.findAllWithSameName(self.meal.name)
        
        var weeks: [String] = []

         for ref in allRefWithSameName{
            weeks.append(ref.diaSemana)
                                
            let date = NSDate()
            let todoItem = TodoItem(deadline: date, title: ref.name , UUID: ref.uuid )
            TodoList.sharedInstance.removeItem(todoItem)
                                
            //Switch notification off: remove uuid from meal
            if !self.notificationSwitch.on {
                ref.uuid = ""
                self.meal.id = ""
            }else{
                //Switch notification on and meal.id empty: genrate uuid
                                  
                ref.uuid = NSUUID().UUIDString
                meal.id = ref.uuid
                                    
                let notification = Notifications()
                let todoItem2 = TodoItem(deadline: notification.scheduleNotifications(ref.diaSemana, dateHour: self.meal.hour), title: self.meal.name, UUID: ref.uuid)
                TodoList.sharedInstance.addItem(todoItem2)
           }
                                
           RefeicaoServices.editRefeicao(ref, name: self.meal.name, horario: self.meal.hour, diaSemana: ref.diaSemana, items: self.meal.foods, uuid: ref.uuid)
                                
        }
        let tempWeek = weeks
         //if the comparison between the old with the new from weeks is false, need to delete the difference
        if(self.daysOfWeekString.compareArray(weeks) == false){
            var i : Int = 0
            for dayOfWeek in tempWeek {
                if(self.daysOfWeekString.isSelected(dayOfWeek) == false){
                    weeks.removeAtIndex(i)
                    RefeicaoServices.deleteMeal(allRefWithSameName[i])
                }
                i++
            }
        }
                            
        if(self.daysOfWeekString.getArrayString().count != weeks.count){
            let new = self.daysOfWeekString.getArrayString()
            var find: Bool = true
            for dayNew in new {
                for dayOld in weeks {
                    if(dayOld == dayNew){
                        find = true
                        break
                    }else{
                        find = false
                    }
                }
                if(find == false){
                    RefeicaoServices.createRefeicao(self.meal.name, horario: self.meal.hour, diaSemana: dayNew, items: self.meal.foods, uuid: self.meal.id!)
                }
            }
        }
        
        self.navigationController?.popViewControllerAnimated(true)
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
       self.modeSave()


        self.meal.hour = timePicker(self.datePicker)
        self.hour.setTitle(self.notification.formatStringTime(meal.hour), forState: .Normal)

    }

    @IBAction func valueChange(sender: AnyObject) {
        self.modeSave()

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
    
    // This function stop shaking the collection view cells
    func stopShakingIcons(layer: CALayer) {
        layer.removeAnimationForKey("shaking")
    }
    
    func longPressed(sender: UILongPressGestureRecognizer)
    {
        if(self.dell == false){
            self.dell = true
            
            self.collectionView.reloadData()
        }
    }
    
    func stopShaking(gestureRecognizer: UITapGestureRecognizer){
        
        if(self.bottomCV.constant != 0){
            self.view.layoutIfNeeded()
            UIView.animateWithDuration(1, animations: {
                self.bottomCV.constant = 0
                self.view.layoutIfNeeded()
            })
        }
        if(self.dell == true){
            self.dell = false
            self.collectionView.reloadData()
        }
    }
   func deleteButton(sender:UIButton) {
        
        let i : Int = (sender.layer.valueForKey("index")!.row) as Int
        self.meal.removeFood(i)
                
        self.itens = self.meal.foods
        
        self.modeSave()

    
        var index: [NSIndexPath] = []
        index.append(sender.layer.valueForKey("index") as! NSIndexPath)
        
        self.collectionView.deleteItemsAtIndexPaths(index)
    }
    
    func modeSave(){
        self.editButton.title = NSLocalizedString("Salvar", comment: "Salvar")
        self.editButton.enabled = true
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
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if(self.dell == false && self.bottomCV.constant == 0){
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
            
//            destinationViewController.transitioningDelegate = self.transitionManager
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeFoodDismiss", name: "ChangeFoodDismiss", object: nil)
            
            destinationViewController.view.frame = CGRectInset(destinationViewController.view.frame, 100, 50)
            
            
            let indexPath = sender as! NSIndexPath
            let foodSelected = itens[indexPath.row]
            
            destinationViewController.itens = ItemCardapioServices.findItemCardapioByCategory(foodSelected.categoria)
            destinationViewController.selectedItemIndex = indexPath.row
            destinationViewController.meal = self.meal
        }else if (segue.identifier == "Week") {
                let destinationViewController = segue.destinationViewController as! WeeksTVC
                destinationViewController.week = self.daysOfWeekString
            }
    }
    
    func changeFoodDismiss() {
        if(self.itens != self.meal.foods){
            //Get the Cardapio itens with the choosed Refeicao uuid
            self.itens = self.meal.foods
            self.modeSave()
            
        }
        self.collectionView.reloadData()
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ChangeFoodDismiss", object: nil)
    }

}
