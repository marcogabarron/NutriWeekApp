//
//  AddItemVC.swift
//  NutriWeekApp
//
//  Created by Gabarron on 29/06/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.
//

import UIKit

class AddItemVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var horario: UIDatePicker!
    
    var json = ReadJson()
    var nutriVC = NutriVC()
    var itens = [ItemCardapio]()
    var selectedItens = [ItemCardapio]()
    
    var daysOfWeekString: Weeks = Weeks(arrayString: ["Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado", "Domingo"])

        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //json.loadFeed()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        itens = ItemCardapioServices.allItemCardapios()
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
        
        cell.item = itens[indexPath.row]
        
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
            self.selectedItens.append(cell.item)
        }else{
            cell.image.layer.borderColor = UIColor.blackColor().CGColor
            cell.textLabel.textColor = UIColor.blackColor()
            //Here is desselected
            var i = 0
            for item in self.selectedItens{
                if(cell.item == item){
                    self.selectedItens.removeAtIndex(i)
                }
                i++
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
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell!.selected = false
        
    }

    //MARK: actions
    
    @IBAction func saveItemButton(sender: AnyObject) {
        if(self.nameTextField.text != ""){
            var i = 0
            if(self.selectedItens.count == 0){
                UIView.animateWithDuration(0.5, delay: 0.0, options: nil, animations: {() -> Void in
                    
                    self.collectionView.backgroundColor = UIColor(red: 255/255, green: 200/255, blue: 255/255, alpha: 1)
                    
                    }, completion: {(result) -> Void in
                        
                        UIView.animateWithDuration(0.3, animations: {() -> Void in
                            
                            self.collectionView.backgroundColor = UIColor.whiteColor()
                            
                        })
                        
                })
                
            
            }else{
                
                for diaSemana in self.daysOfWeekString.getArrayString(){
                    
                    //Não esta savaldo nenhum Item caradapio!!!!!!
                    //use a array self.selectedItens para salvar os itens
                    
                    RefeicaoServices.createRefeicao(self.nameTextField.text, horario: TimePicker(self.horario), diaSemana: diaSemana)
                }
                
                

                self.nameTextField.text = ""
            }
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
    
    func TimePicker(sender: UIDatePicker) -> String{
        
        var timer = NSDateFormatter()
        
        timer.dateFormat = "HH:mm:ss"
        
        timer.timeStyle = NSDateFormatterStyle.ShortStyle
        
        var strdate = timer.stringFromDate(sender.date)
        
        return strdate
        
    }
    
    @IBAction func UpdateTimerPicker(sender: AnyObject) {
        
        TimePicker(self.horario)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "Week") {
            let destinationViewController = segue.destinationViewController as! WeeksTableViewController
            destinationViewController.week = self.daysOfWeekString
        }
    }

}
