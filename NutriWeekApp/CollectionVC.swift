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
    @IBOutlet weak var hour: UILabel!
    
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
        self.hour.text = self.notification.formatStringTime(meal.hour)
        
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
            
            cell.dellImage.hidden = true
            
        }else{
            cell.textLabel.text = itens[indexPath.row].name
            cell.textLabel.autoresizesSubviews = true
            
            cell.image.image = UIImage(named: "\(itens[indexPath.row].image)")
            cell.image.layer.masksToBounds = true
            cell.image.layer.cornerRadius = cell.frame.width/3
            
            if(dell == true){
                cell.dellImage.hidden = false
                
                let tapDell = UITapGestureRecognizer(target: self, action: "deletePressed:")
                cell.dellView.addGestureRecognizer(tapDell)


            }else{
                cell.dellImage.hidden = true

                let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressed:")
                cell.view.addGestureRecognizer(longPressRecognizer)
            }
        }
        
        
        
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == self.itens.count){
            self.performSegueWithIdentifier("Add", sender: self)
        }
        
        self.dell = false
        
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
    
    func deletePressed(sender: UITapGestureRecognizer)
    {
        self.dell = false
        
        self.collectionView.reloadData()
        
    }
    
    @IBAction func save(sender: AnyObject) {
        
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
