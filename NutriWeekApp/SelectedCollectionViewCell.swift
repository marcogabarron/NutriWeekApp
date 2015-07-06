//
//  SelectedCollectionViewCell.swift
//  NutriWeekApp
//
//  Created by Jessica Oliveira on 06/07/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.
//

import UIKit

class SelectedCollectionViewCell: UICollectionViewCell {
    var nada: Bool = false
    
    @IBOutlet weak var viewCell: UIView!
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    
    
    
//    @IBAction func changeLabelText(sender: AnyObject) {
//        if(self.nada == false){
//            self.viewCell.backgroundColor = UIColor.greenColor()
//        }else{
//            self.viewCell.backgroundColor = UIColor.redColor()
//        }
//        self.nada = !self.nada
//        
//    }
}
