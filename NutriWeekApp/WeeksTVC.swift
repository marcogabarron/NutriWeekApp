//
//  WeeksTableViewController.swift
//  NutriWeekApp
//
//  Created by Jessica Oliveira on 07/07/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.
//

import UIKit

class WeeksTVC: UITableViewController {
    
    ///Navigation title
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    ///Set the possible repeat days
    let daysInPt: [String] = ([ "Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado"])
    
    ///Interact with Weeks model
    var weekDays: Weeks!
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationTitle.title = NSLocalizedString("Repetir", comment: "")
    }
    
    
    //MARK: TableView
    
    /** Write the name of the cell **/
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        cell.textLabel?.text = NSLocalizedString(self.daysInPt[indexPath.row], comment: "")
        
        //Says it is selected or not
        if(self.weekDays.isSelected(self.daysInPt[indexPath.row])){
            cell.accessoryType = .Checkmark
        }else{
            cell.accessoryType = .None
        }
        
        return cell
    }

    /** Select and deselect cell, adding or removing days of array **/
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if(self.weekDays.getArrayString().count != 1){
            
                if cell!.accessoryType == .Checkmark {
                    cell!.accessoryType = .None
                    self.removeDay(self.daysInPt[indexPath.row])
                    
                } else {
                    cell!.accessoryType = .Checkmark
                    self.addDay(self.daysInPt[indexPath.row])
                }
        }
        cell?.selected = false
    }
    
    //MARK: functions
    
    /** Remove day deselect **/
    func removeDay(day: String){
        for index in 0...self.weekDays.getArrayString().count{
            if( self.weekDays.getArrayString()[index] == day){
                self.weekDays.removeDayAtIndex(index)
                break
            }
        }
    }
    
    /** Add day select **/
    func addDay(day: String){
        self.weekDays.appendDay(day)
    }
    
    
    //MARK: Prepare for segue
    
    /** Prepare for segue back **/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "Week") {
            let destinationViewController = segue.destinationViewController as! AddItemVC
            destinationViewController.daysOfWeekString = self.weekDays
        }
    }
    
}
