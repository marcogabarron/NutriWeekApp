//
//  WeeksTableViewController.swift
//  NutriWeekApp
//
//  Created by Jessica Oliveira on 07/07/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.
//

import UIKit

class WeeksTableViewController: UITableViewController {
    
    var week:Weeks!
    
    var arrayFix: [String] = (["Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado", "Domingo"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        cell.textLabel?.text = self.arrayFix[indexPath.row]
        
        if(self.week.findString(self.arrayFix[indexPath.row])){
            cell.accessoryType = .Checkmark
        }else{
            cell.accessoryType = .None
        }
        
        return cell
        
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if cell.accessoryType == .Checkmark
            {
                cell.accessoryType = .None
                self.removeDay(cell.textLabel!.text!)
            }
            else
            {
                cell.accessoryType = .Checkmark
                self.addDay(cell.textLabel!.text!)
            }
            cell.selected = false
        }
    }
    
    func removeDay(day: String){
        for i in 0...self.week.getArrayString().count{
            if( self.week.getArrayString()[i] == day){
                self.week.removeAtIndex(i)
                break
            }
        }
    }
    
    
    func addDay(day: String){
        self.week.append(day)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "Week") {
            let destinationViewController = segue.destinationViewController as! AddItemVC
            destinationViewController.daysOfWeekString = self.week
        }
    }
    
}
