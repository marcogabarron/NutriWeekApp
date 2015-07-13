//
//  CollectionVC.swift
//  NutriWeekApp
//
//  Created by Gabarron on 03/07/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.
//

import UIKit

class CollectionVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var json = ReadJson()
    var itens = [ItemCardapio]()
    var colorImage = UIColor.blackColor().CGColor
    var selectedItens = [ItemCardapio]()
    
    var selectedRefeicao:String!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(self.selectedRefeicao)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //a partir da refeicao pegar seis Itens cardapios
        var refeicao: Refeicao = RefeicaoServices.findByName(self.selectedRefeicao)
        self.itens = refeicao.getItemsObject()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: CollectionView
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itens.count //json.listaAlimentos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CollectionCell

        
        cell.myButton.setTitle(self.itens[indexPath.row].name, forState: .Normal)
        /*"(json.listaAlimentos[indexPath.row].nomeAlimento)"*/
        cell.myImage.image = UIImage(named: "\(itens[indexPath.row].image)")
        
        
        //json.listaAlimentos[indexPath.row].imagemAlimento)
            //"\(itens[indexPath.row].nameImage)")
        
        /*json.listaAlimentos[indexPath.row].imagemAlimento*/
        cell.myImage.layer.masksToBounds = true
        cell.myImage.layer.cornerRadius = cell.frame.width/3
        cell.layer.cornerRadius = cell.frame.width/4
        cell.myImage.layer.borderWidth = 2
        cell.myImage.layer.borderColor = colorImage
        
        cell.item = self.itens[indexPath.row]
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as! CollectionCell
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: nil, animations: {() -> Void in
            
            cell.transform = CGAffineTransformMakeScale(1.05, 1.05)
            
            }, completion: {(result) -> Void in
                
                UIView.animateWithDuration(0.3, animations: {() -> Void in
                    
                    cell.transform = CGAffineTransformMakeScale(1.0, 1.0)
                    
                })
                
        })
        
        if(cell.click == false){
            cell.myImage.layer.borderColor = UIColor(red: 40/255, green: 180/255, blue: 50/255, alpha: 1).CGColor
            cell.myButton.tintColor = UIColor(red: 40/255, green: 180/255, blue: 50/255, alpha: 1)
            
            //Here is selected
            self.selectedItens.append(cell.item)
        }else{
            cell.myImage.layer.borderColor = UIColor.blackColor().CGColor
            cell.myButton.tintColor = UIColor.blackColor()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
