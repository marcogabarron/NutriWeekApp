//
//  CollectionVC.swift
//  NutriWeekApp
//
//  Created by Gabarron on 03/07/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.


import UIKit

class CollectionVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {
  
    //MARK: IBOutlets and other variables and constants
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var notificationSwitch: UISwitch!    //     important for translation
    @IBOutlet weak var notificationLabel: UILabel!    

    @IBOutlet weak var datePicker: UIDatePicker!
    ///Constraint`s controller to datePicker appear
    @IBOutlet weak var bottomCV: NSLayoutConstraint!
    
//    @IBOutlet weak var name: UILabel! //Pode tirar?
    @IBOutlet weak var hour: UIButton!
    
    
    //Relative to models and CoreData
    var foods = [ItemCardapio]()
    var format = FormatDates()
    var meal: Meal!
    
    ///Manage meal frequency at week
    var mealWeekDays: Weeks = Weeks(selectedDays: [])
    
    ///Get the other equal meals at the other weekDays
    var mealsWithSameName: [Refeicao]!

    //var colorImage = UIColor.blackColor().CGColor //precisa?
    var delButtonAppears: Bool = false
    
    //tracker - Google Analytics
    let tracker = GAI.sharedInstance().trackerWithTrackingId("UA-70701653-1")
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Inits disabled because there is no changes do save
        self.saveButton.title = NSLocalizedString("Salvar", comment: "Salvar")
        self.saveButton.enabled = false
        
        //Passing selected meal foods to actual current foods
        self.foods = self.meal.foods

        self.mealsWithSameName = RefeicaoServices.findAllWithSameName(self.meal.name)
            for meal in self.mealsWithSameName {
                self.mealWeekDays.appendDay(meal.diaSemana)
            }
        self.mealWeekDays.change = false
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewWillAppear(animated: Bool) {
        
        //Google Analytics - monitoring screens
        tracker.set(kGAIScreenName, value: "See diet")
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        
        
        //language
        self.navigationItem.title = NSLocalizedString("Refeição", comment: "Refeição")
        self.notificationLabel.text = NSLocalizedString("Notificação", comment: "Notification")
        
        //Get meal name and hour
        self.navigationItem.title = self.meal.name
        self.hour.setTitle(self.format.formatStringTime(meal.hour), forState: .Normal)
        
        //Allows collection view multiple selections
        self.collectionView.allowsMultipleSelection = true

        if(self.foods != self.meal.foods){
            //Get the Cardapio itens with the choosed Refeicao uuid
            self.foods = self.meal.foods
            self.saveButton.enabled = true
            
        }
        
        if(self.mealWeekDays.change){
            self.saveButton.enabled = true
        }
        
        //Tap to stop shaking - if there are shaking
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
    //Show meal foods saved

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foods.count + 1
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //created collection view cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath) as! CollectionCell

        if(Int(indexPath.row) == self.foods.count){
            cell.textLabel.text = ""

            cell.image.image = UIImage(named: "addButton")
            cell.image.layer.masksToBounds = true
            cell.image.layer.cornerRadius = cell.frame.width/3
            
            cell.dellButton.hidden = true
            
        }else{
            cell.textLabel.text = foods[indexPath.row].name
            cell.textLabel.autoresizesSubviews = true
            
            cell.image.image = UIImage(named: "\(foods[indexPath.row].image)")
            cell.image.layer.masksToBounds = true
            cell.image.layer.cornerRadius = cell.frame.width/3
            
            if(delButtonAppears == true){
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
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerViewLabel = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "headerView", forIndexPath: indexPath) as! CollectionDiaryClass
            
            return headerViewLabel
            
        default:
            assert(false, "Unexpected element kind")
            }
    }

    //selected colletion view cell
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == self.foods.count){
            self.performSegueWithIdentifier("Add", sender: self)
        }
        else if self.delButtonAppears {
            self.delButtonAppears = false
        }
        else {
            self.performSegueWithIdentifier("ChangeFood", sender: indexPath)
        }
        
        self.collectionView.reloadData()
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
            for day in self.mealWeekDays.getArrayString(){
                if(buildDetail != " "){
                    buildDetail = buildDetail.stringByAppendingString(", ")
                }
                
                switch day {
                case "Domingo":
                    buildDetail = buildDetail.stringByAppendingString(NSLocalizedString("dom", comment: ""))
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

    @IBAction func save(sender: AnyObject) {
        
        self.mealsWithSameName = RefeicaoServices.findAllWithSameName(self.meal.name)
        var tempWeekDays: [String] = []

        for tempMeal in self.mealsWithSameName{
            tempWeekDays.append(tempMeal.diaSemana)
                            
            TodoList.sharedInstance.removeItemById(tempMeal.uuid)
            
            //Switch notification off: remove uuid from meal
            if !self.notificationSwitch.on {
                tempMeal.uuid = ""
                
            }else{
                //Switch notification on and meal.id empty: genrate uuid
                if tempMeal.uuid == "" {
                tempMeal.uuid = NSUUID().UUIDString
                }
            }
            
            let todoItem = TodoItem(deadline: self.format.setNotificationDate(tempMeal.diaSemana, dateHour: self.meal.hour), title: self.meal.name, UUID: tempMeal.uuid)
            TodoList.sharedInstance.addItem(todoItem)
            
            RefeicaoServices.editRefeicao(tempMeal, name: self.meal.name, horario: self.meal.hour, diaSemana: tempMeal.diaSemana, items: self.meal.foods, uuid: tempMeal.uuid)
        }
        
        //If received week and the new setted week, needs to delete the difference
        if !self.mealWeekDays.compareWeeks(tempWeekDays) {
            var index  = 0
            for weekDay in tempWeekDays {
                if(self.mealWeekDays.isSelected(weekDay) == false){
                    tempWeekDays.removeAtIndex(index)
                    RefeicaoServices.deleteMeal(self.mealsWithSameName[index])

                }
                index++
            }
        }
                            
        if(self.mealWeekDays.getArrayString().count != tempWeekDays.count){
            let tempWeek = self.mealWeekDays.getArrayString()
            var find: Bool = true
            
            for compareDay in tempWeek {
                for day in tempWeekDays {
                    
                    if(day == compareDay){
                        find = true
                        break
                        
                    } else {
                        find = false
                    }
                }
                
                if(find == false){
                    RefeicaoServices.createRefeicao(self.meal.name, horario: self.meal.hour, diaSemana: compareDay, items: self.meal.foods, uuid: NSUUID().UUIDString)
                }
            }
        }
        //Google Analytics - monitoring events - dicover created food
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("Button Save", action: "Edit diet", label: nil , value: nil).build() as [NSObject : AnyObject])
        
        self.navigationController?.popViewControllerAnimated(true)
    }

    
    @IBAction func datePickerAppear(sender: AnyObject) {
        
        if(self.bottomCV.constant == 0){
            
            self.datePicker.date = self.format.formatStringToDate(self.meal.hour)
            
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
        self.saveButton.enabled = true

        self.meal.hour = self.format.formatDateToString(self.datePicker.date)
        self.hour.setTitle(self.format.formatStringTime(meal.hour), forState: .Normal)
    }

    
    @IBAction func valueChange(sender: AnyObject) {
        self.saveButton.enabled = true
    }
    
    
    //MARK: Functions
    
    /** Stops shaking the collection view cells **/
    func stopShakingIcons(layer: CALayer) {
        layer.removeAnimationForKey("shaking")
    }
    
    
    func longPressed(sender: UILongPressGestureRecognizer)
    {
        if(self.delButtonAppears == false){
            self.delButtonAppears = true

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
        if(self.delButtonAppears == true){
            self.delButtonAppears = false
            self.collectionView.reloadData()
        }
    }
    
    
   func deleteButton(sender:UIButton) {
    
        self.meal.removeFood((sender.layer.valueForKey("index")!.row) as Int)
                
        self.foods = self.meal.foods
        self.saveButton.enabled = true

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

    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if(self.delButtonAppears == false && self.bottomCV.constant == 0){
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
            
        } else if (segue.identifier == "ChangeFood") {
            let destinationViewController = segue.destinationViewController as! ChangeFoodVC
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeFoodDismiss", name: "ChangeFoodDismiss", object: nil)
            
            destinationViewController.view.frame = CGRectInset(destinationViewController.view.frame, 100, 50)
            
            let indexPath = sender as! NSIndexPath
            let foodSelected = foods[indexPath.row]
            
            destinationViewController.itens = ItemCardapioServices.findItemCardapioByCategory(foodSelected.categoria)
            destinationViewController.selectedItemIndex = indexPath.row
            destinationViewController.meal = self.meal
            
        } else if (segue.identifier == "Week") {
                let destinationViewController = segue.destinationViewController as! RepeatTVC
                destinationViewController.weekDays = self.mealWeekDays
            }
    }
    
    func changeFoodDismiss() {
        if(self.foods != self.meal.foods){
            //Get the Cardapio itens with the choosed Refeicao uuid
            self.foods = self.meal.foods
            self.saveButton.enabled = true
        }
        
        self.collectionView.reloadData()
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ChangeFoodDismiss", object: nil)
    }
}
