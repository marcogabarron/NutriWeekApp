//
//  AddItemVC.swift
//  NutriWeekApp
//
//  Created by Gabarron on 29/06/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.
//

import UIKit

class AddItemVC: UIViewController{

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



}
