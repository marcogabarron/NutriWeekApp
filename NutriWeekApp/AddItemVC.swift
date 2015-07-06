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

    @IBOutlet weak var quarSwitch: UISwitch!
    @IBOutlet weak var terSwitch: UISwitch!
    @IBOutlet weak var segSwitch: UISwitch!
    @IBOutlet weak var textField: UITextField!
    var nutriVC = NutriVC()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
                
    }

    @IBAction func InsertButton(sender: UIButton) {
        
        ItemCardapioServices.createItemCardapio(textField.text)
        nutriVC.items = ItemCardapioServices.allItemCardapios()
        textField.text = ""
        //nutriVC.tableView.reloadData()
        println("funciona um reload data aqui?")
        
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SelectedCollectionViewCell", forIndexPath: indexPath) as! SelectedCollectionViewCell
        
        cell.textLabel.text = "Pão Francês"
        cell.textLabel.tintColor = UIColor.whiteColor()
        cell.textLabel.preservesSuperviewLayoutMargins = true
        
        cell.image.image = UIImage(named: "franc")
        cell.image.layer.masksToBounds = true
        
        cell.image.layer.cornerRadius = cell.image.frame.width/3
        cell.viewCell.layer.cornerRadius = cell.viewCell.frame.width/3
        return cell
    }



}
