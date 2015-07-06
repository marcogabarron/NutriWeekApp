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
    
    var nutriVC = NutriVC()

    
    var Array = [String]()
    var ArrayImages = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        Array = ["Pao de Queijo", "Morango", "Leite", "Uva", "Feijão", "Ovo Cozido", "Batata Cozida", "Cenoura", "Barra de Cereal", "Queijo", "Frango Grelhado", "Alface", "Bife", "Suco de Laranja", "Chá de Pessego", "Tomate", "Arroz Branco", "Água"]
        ArrayImages = ["cheesebread.jpg", "strawberry.jpg", "milk.jpg", "grape.jpg", "bean.jpg", "boiledegg.jpg", "boiledpotato.jpg", "carrot.jpg", "cerealbar.jpg", "cheese.jpg", "grilledckicken.jpg", "lettuce.jpg", "met.jpg", "orangejuice.jpg", "peachtea.jpg", "tomato.jpg", "whiterice.jpg", "water.jpg"]
        
    }
    

    @IBAction func saveItemButton(sender: AnyObject) {
        if(self.nameTextField.text != ""){
            ItemCardapioServices.createItemCardapio(self.nameTextField.text)
            nutriVC.items = ItemCardapioServices.allItemCardapios()
            self.nameTextField.text = ""
        }else{
            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: nil, animations:({
                
                
                self.nameTextField.frame = CGRectMake(self.nameTextField.frame.origin.x, self.nameTextField.frame.origin.y, self.nameTextField.frame.width+20, self.nameTextField.frame.height+20)
                
                
            }), completion: {(result) -> Void in
                
                UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: nil, animations:({
                    
                    
                    self.nameTextField.frame = CGRectMake(self.nameTextField.frame.origin.x, self.nameTextField.frame.origin.y, self.nameTextField.frame.width-20, self.nameTextField.frame.height-20)
                    
                }), completion: {(result) -> Void in
                })
            })
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return Array.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SelectedCollectionViewCell", forIndexPath: indexPath) as! SelectedCollectionViewCell
        
        cell.textLabel.text = "\(Array[indexPath.row])"
        cell.textLabel.preservesSuperviewLayoutMargins = true
        
        cell.image.image = UIImage(named: ArrayImages[indexPath.row])
        cell.image.layer.masksToBounds = true
        
        cell.image.layer.cornerRadius = cell.image.frame.width/3
        cell.viewCell.layer.cornerRadius = cell.viewCell.frame.width/3
        return cell
    }



}
