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
        
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath) as! CollectionCell

        self.dell = false
        
        self.stopShakingIcons(cell.layer)
        
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
    
    @IBAction func save(sender: AnyObject) {
        
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
        
        self.meal.hour = timePicker(self.datePicker)
        self.hour.setTitle(self.notification.formatStringTime(meal.hour), forState: .Normal)

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
    
    //MARK - Prepare for segue
    /** Prepare for Segue to Edit page -- pass the uuid information from cell clicked  **/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "Add") {
            let destinationViewController = segue.destinationViewController as! SelectedFoodsVC
          
            destinationViewController.meal = self.meal
        }
    }

}
