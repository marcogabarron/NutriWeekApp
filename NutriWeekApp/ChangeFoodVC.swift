//
//  ChangeFoodVC.swift
//  NutriWeekApp
//
//  Created by Gabriel Maciel Bueno Luna Freire on 27/10/15.
//  Copyright © 2015 Gabarron. All rights reserved.
//


import UIKit

class ChangeFoodVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {
    
    //MARK: IBOutlets and other variables and constants
    @IBOutlet weak var collectionView: UICollectionView!
    
    //Relative to models and CoreData
    var itens = [ItemCardapio]()
    var selectedItens = [ItemCardapio]()
    var meal: Meal!
    
    ///Selected food from CollectionVC
    var selectedItemIndex: Int!
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: "bringImageToFront:")
        tap.numberOfTapsRequired = 1
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.view.frame = CGRect(origin: self.view.frame.origin, size: CGSize(width: self.view.frame.size.width / 2, height: self.view.frame.size.height / 2))
        
        self.collectionView.layer.masksToBounds = true
        self.collectionView.layer.cornerRadius = self.collectionView.frame.height/5
        
        //Allows multiple selections
        self.collectionView.allowsMultipleSelection = true
        self.collectionView.reloadData()
        
    }
    
    
    //MARK: CollectionView
    
    //Show meal foods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itens.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("SelectedCollectionViewCell", forIndexPath: indexPath) as! SelectedCollectionViewCell
        
        cell.textLabel.text = itens[indexPath.row].name
        cell.textLabel.autoresizesSubviews = true
            
        cell.image.image = UIImage(named: "\(itens[indexPath.row].image)")
        cell.image.layer.masksToBounds = true
        cell.image.layer.cornerRadius = cell.frame.width/3
        
        cell.checkImage.hidden = true
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.meal.foods[self.selectedItemIndex] = self.itens[indexPath.row]
        
        closeModal()
    }
    
    
    //MARK: Actions
    @IBAction func bringImageToFront(gestureRecognizer: UITapGestureRecognizer) {
        closeModal()
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if touch.view!.isDescendantOfView(self.collectionView) {
            return false
        }
        return true
    }
    
    
    //MARK: Function/"Prepare for segue"(Dismiss)
    func closeModal() {
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "ChangeFoodDismiss", object: nil))
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
