//
//  CollectionVC.swift
//  NutriWeekApp
//
//  Created by Gabarron on 03/07/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.
//

import UIKit

class CollectionVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var itens = [ItemCardapio]()
    var colorImage = UIColor.blackColor().CGColor
    var selectedItens = [ItemCardapio]()
    
    var refeicaoID: String!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var hour: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        //a partir da refeicao pegar seis Itens cardapios
        var refeicao: Refeicao = RefeicaoServices.findByUuid(self.refeicaoID)
        self.itens = refeicao.getItemsObject()
        
        //get name and time
        self.name.text = refeicao.name
        self.hour.text = self.formatTime(refeicao.horario)
        
        self.collectionView.reloadData()
        
    }
    
    //MARK: Logic Functions
    
    //get string and returns a string formatted with local time zone
    func formatTime(dataString: String) -> String{
        
        var dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        
        let dateValue = dateFormatter.dateFromString(dataString)
        
        
        var stringFormatted = NSDateFormatter.localizedStringFromDate(dateValue!, dateStyle: .NoStyle, timeStyle: .ShortStyle)
        
        
        return stringFormatted
        
    }
    
    //checks whether the item is selected
    func find(itemNew: ItemCardapio)->Bool{
        var re : Bool = false
        for item in self.selectedItens{
            if(itemNew == item){
                re = true
            }
        }
        return re
    }
    
    //MARK: CollectionView
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itens.count //json.listaAlimentos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CollectionCell

        
        cell.myButton.setTitle(self.itens[indexPath.row].name, forState: .Normal)
        cell.myImage.image = UIImage(named: "\(itens[indexPath.row].image)")
        
        cell.myImage.layer.masksToBounds = true
        cell.myImage.layer.cornerRadius = cell.frame.width/3
        cell.layer.cornerRadius = cell.frame.width/4
        
        if(self.find(self.itens[indexPath.row])){
            cell.myImage.layer.borderColor = UIColor(red: 40/255, green: 180/255, blue: 50/255, alpha: 1).CGColor
            cell.myButton.tintColor = UIColor(red: 40/255, green: 180/255, blue: 50/255, alpha: 1)
            cell.click = true
            
        }else{
            cell.myImage.layer.borderColor = UIColor.blackColor().CGColor
            cell.myButton.tintColor = UIColor.blackColor()
            cell.click = false
        }
        
        return cell
        
    }
    
    
    //select and deselect cell
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as! CollectionCell
        
        //animation
        UIView.animateWithDuration(0.3, delay: 0.0, options: nil, animations: {() -> Void in
            
            cell.transform = CGAffineTransformMakeScale(1.05, 1.05)
            
            }, completion: {(result) -> Void in
                
                UIView.animateWithDuration(0.3, animations: {() -> Void in
                    
                    cell.transform = CGAffineTransformMakeScale(1.0, 1.0)
                    
                })
                
        })
        
        //selected
        if(cell.click == false){
            cell.myImage.layer.borderColor = UIColor(red: 40/255, green: 180/255, blue: 50/255, alpha: 1).CGColor
            cell.myButton.tintColor = UIColor(red: 40/255, green: 180/255, blue: 50/255, alpha: 1)
            
            //Here is selected
            self.selectedItens.append(self.itens[indexPath.row])
            
        }else{
            
            //deselect
            cell.myImage.layer.borderColor = UIColor.blackColor().CGColor
            cell.myButton.tintColor = UIColor.blackColor()
            //Here is desselected
            var i = 0
            for item in self.selectedItens{
                if(self.itens[indexPath.row] == item){
                    self.selectedItens.removeAtIndex(i)
                }
                i++
            }
        }
        
        cell.click = !cell.click
        
    }
    
    //prepare for Segue to Edit page
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "Edit") {
            let destinationViewController = segue.destinationViewController as! EditVC
            var refeicao: Refeicao = RefeicaoServices.findByUuid(self.refeicaoID)
            destinationViewController.refeicao = refeicao
        }else{
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
