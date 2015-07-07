//
//  WeeksTableViewController.swift
//  NutriWeekApp
//
//  Created by Jessica Oliveira on 07/07/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.
//

import UIKit

class WeeksTableViewController: UITableViewController {

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if cell.accessoryType == .Checkmark
            {
                cell.accessoryType = .None
            }
            else
            {
                cell.accessoryType = .Checkmark
            }
            cell.selected = false
        }
    }
    
}
