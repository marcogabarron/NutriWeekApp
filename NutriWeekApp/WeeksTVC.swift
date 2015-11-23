//
//  WeeksTableViewController.swift
//  NutriWeekApp
//
//  Created by Jessica Oliveira on 07/07/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.
//

import UIKit

class WeeksTVC: UITableViewController {
    
    ///RepeatStrng
    @IBOutlet weak var `repeat`: UINavigationItem!
    
    ///Interact with Weeks model
    var week:Weeks!
    
    var arrayFix: [String] = ([ "Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        `repeat`.title = NSLocalizedString("Repetir", comment: "")
        
    }
    
    /** Write the name of the cell **/
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        cell.textLabel?.text = NSLocalizedString(self.arrayFix[indexPath.row], comment: "")
        
        //Says it is selected or not
        if(self.week.isSelected(self.arrayFix[indexPath.row])){
            cell.accessoryType = .Checkmark
        }else{
            cell.accessoryType = .None
        }
        
        return cell
        
    }

    /** Select and deselect cell, adding or removing days of array **/
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if(self.week.getArrayString().count != 1){
            
                if cell!.accessoryType == .Checkmark
                {
                    cell!.accessoryType = .None
                    self.removeDay(self.arrayFix[indexPath.row])
                }
                else
                {
                    cell!.accessoryType = .Checkmark
                    self.addDay(self.arrayFix[indexPath.row])
                }
            
        }
        cell?.selected = false
        
    }
    
    /** Remove day deselect **/
    func removeDay(day: String){
        for index in 0...self.week.getArrayString().count{
            if( self.week.getArrayString()[index] == day){
                self.week.removeDayAtIndex(index)
                break
            }
        }
    }
    
    /** Add day select **/
    func addDay(day: String){
        self.week.appendDay(day)
    }
    
    /** Prepare for segue back **/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "Week") {
            let destinationViewController = segue.destinationViewController as! AddItemVC
            destinationViewController.daysOfWeekString = self.week
        }
    }
    
}
