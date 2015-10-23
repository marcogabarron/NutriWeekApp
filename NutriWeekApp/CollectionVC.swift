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
    
    ///Get the uuid of choosed Refeicao
    var refeicaoID: String!
    
    //Relative to collection View
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var hour: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.editButton.title = NSLocalizedString("Editar", comment: "Editar")
        self.refeicao.title = NSLocalizedString("Refeição", comment: "Editar")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        ///Find Refeicao by uuid
        let refeicao: Refeicao = RefeicaoServices.findByUuid(self.refeicaoID)
        //Get the Cardapio itens with the choosed Refeicao uuid
        self.itens = refeicao.getItemsObject()
        
        //Get Refeicao`s name and time
        self.name.text = refeicao.name
        self.hour.text = notification.formatStringTime(refeicao.horario)
        
        //allows multiple selections
        self.collectionView.allowsMultipleSelection = true
        
        self.collectionView.reloadData()
        
    }
    
    //MARK: CollectionView
    // show the items save in the Core Data
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itens.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CollectionCell

        cell.myLabel.text = itens[indexPath.row].name
        cell.myLabel.autoresizesSubviews = true
        
        cell.myImage.image = UIImage(named: "\(itens[indexPath.row].image)")
        cell.myImage.layer.masksToBounds = true
        cell.myImage.layer.cornerRadius = cell.frame.width/3
        
        
        //change the label color when it is already selected - It is within the selected array
        if(self.isSelected(self.itens[indexPath.row])){
            cell.myLabel.textColor = UIColor(red: 40/255, green: 180/255, blue: 50/255, alpha: 1)
            
        }else{
            cell.myLabel.textColor = UIColor.blackColor()
        }
        
        return cell
        
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
    
    //MARK - Prepare for segue
    /** Prepare for Segue to Edit page -- pass the uuid information from cell clicked  **/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "Edit") {
            let destinationViewController = segue.destinationViewController as! EditVC
            let refeicao: Refeicao = RefeicaoServices.findByUuid(self.refeicaoID)
            destinationViewController.refeicao = refeicao
        }
    }

}
