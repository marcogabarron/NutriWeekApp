//
//  CollectionVC.swift
//  NutriWeekApp
//
//  Created by Gabarron on 03/07/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.
//

import UIKit

class CollectionVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var Array = [String]()
    var ArrayImages = [String]()
    var colorImage = UIColor.blackColor().CGColor
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var alimentos = Alimentos()
        alimentos.loadFeed()
        Array = alimentos.alimentosJson.sorted(<)
        ArrayImages = alimentos.alimentosImages.sorted(<)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: CollectionView
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Array.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CollectionCell

        
        cell.myButton.setTitle("\(Array[indexPath.row])", forState: .Normal)
        
        cell.myImage.image = UIImage(named: ArrayImages[indexPath.row])
        cell.myImage.layer.masksToBounds = true
        cell.myImage.layer.cornerRadius = cell.frame.width/3
        cell.layer.cornerRadius = cell.frame.width/4
        cell.myImage.layer.borderWidth = 2
        cell.myImage.layer.borderColor = colorImage
        
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
        }else{
            cell.myImage.layer.borderColor = UIColor.blackColor().CGColor
            cell.myButton.tintColor = UIColor.blackColor()
            //Here is desselected
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
