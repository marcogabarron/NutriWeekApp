//
//  WeeksTableViewController.swift
//  NutriWeekApp
//
//  Created by Jessica Oliveira on 07/07/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.
//

import UIKit

class WeeksTableViewController: UITableViewController {
    
    ///RepeatStrng
    @IBOutlet weak var repeat: UINavigationItem!
    
    ///Interact with Weeks model
    var week:Weeks!
    var notification = Notifications()
    
    var arrayFix: [String] = (["Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado", "Domingo"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        repeat.title = NSLocalizedString("Repetir", comment: "")
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
                    self.removeDay(notification.translate(cell!.textLabel!.text!))
                }
                else
                {
                    cell!.accessoryType = .Checkmark
                    self.addDay(notification.translate(cell!.textLabel!.text!))
                }
            
        }
        cell?.selected = false
        
    }
    
    /** Remove day deselect **/
    func removeDay(day: String){
        for index in 0...self.week.getArrayString().count - 1 {
            if( self.week.getArrayString()[index] == day){
                self.week.removeAtIndex(index)
                break
            }
        }
    }
    
    /** Add day select **/
    func addDay(day: String){
        self.week.append(day)
    }
    

    
    /** Prepare for segue back **/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "Week") {
            let destinationViewController = segue.destinationViewController as! AddItemVC
            destinationViewController.daysOfWeekString = self.week
        }
    }
    
}
