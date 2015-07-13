//
//  AddItemVC.swift
//  NutriWeekApp
//
//  Created by Gabarron on 29/06/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.
//

import UIKit

class AddItemVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UISearchBarDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var horario: UIDatePicker!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var json = ReadJson()
    var nutriVC = NutriVC()
    var itens = [ItemCardapio]()
    
    var daysOfWeekString: Weeks = Weeks(arrayString: ["Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado", "Domingo"])
    var searchActive : Bool = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        itens = ItemCardapioServices.allItemCardapios()
        searchBar.text = ""
    }
    
    //MARK: To use SearchBar
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(searchBar.text == ""){
            searchActive = false;
            itens = ItemCardapioServices.allItemCardapios()
        } else {
            searchActive = true;
            itens = ItemCardapioServices.findItemCardapio(searchBar.text, image: "\(searchBar.text)")
        }
        self.collectionView.reloadData()
    }
    
    
    //MARK: CollectionView
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return itens.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SelectedCollectionViewCell", forIndexPath: indexPath) as! SelectedCollectionViewCell
        
        cell.textLabel.text = itens[indexPath.row].name
        cell.textLabel.textColor = UIColor.blackColor()
        
        cell.image.image = UIImage(named:itens[indexPath.row].image)
        cell.image.layer.masksToBounds = true
        cell.image.layer.cornerRadius = cell.image.frame.width/3
        cell.image.layer.borderWidth = 2
        cell.image.layer.borderColor = UIColor.blackColor().CGColor
        
        cell.layer.cornerRadius = cell.frame.width/4
        
        return cell
        
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as! SelectedCollectionViewCell
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: nil, animations: {() -> Void in
            
            cell.transform = CGAffineTransformMakeScale(1.05, 1.05)
            
            }, completion: {(result) -> Void in
                
                UIView.animateWithDuration(0.3, animations: {() -> Void in
                    
                    cell.transform = CGAffineTransformMakeScale(1.0, 1.0)
                    
                })
                
        })
        
        if(cell.click == false){
            cell.image.layer.borderColor = UIColor(red: 40/255, green: 180/255, blue: 50/255, alpha: 1).CGColor
            cell.textLabel.textColor = UIColor(red: 40/255, green: 180/255, blue: 50/255, alpha: 1)
            //Here is selected
            
        }else{
            cell.image.layer.borderColor = UIColor.blackColor().CGColor
            cell.textLabel.textColor = UIColor.blackColor()
            //Here is desselected
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
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell!.selected = false
        
    }

    //MARK: actions
    @IBAction func saveItemButton(sender: AnyObject) {
        if(self.nameTextField.text != ""){
            RefeicaoServices.createRefeicao(self.nameTextField.text, horario: "teste", diaSemana: "Semana Teste")
        self.nameTextField.text = ""
    }else{
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "Week") {
        let destinationViewController = segue.destinationViewController as! WeeksTableViewController
        destinationViewController.week = self.daysOfWeekString
        }
    }
    
    func TimePicker(sender: UIDatePicker) -> String{
        
        var timer = NSDateFormatter()
        
        timer.dateFormat = "HH:mm:ss"
        
        timer.timeStyle = NSDateFormatterStyle.ShortStyle
        
        var strdate = timer.stringFromDate(sender.date)
        
        println(strdate)
        
        return strdate
        
    }
    
    @IBAction func UpdateTimerPicker(sender: AnyObject) {
        
        TimePicker(horario)
        
    }
}
