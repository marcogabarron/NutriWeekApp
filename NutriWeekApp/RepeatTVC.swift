//
//  WeeksTableViewController.swift
//  NutriWeekApp
//
//  Created by Jessica Oliveira on 07/07/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.
//

import UIKit

class RepeatTVC: UITableViewController {
    
    ///Navigation title
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    ///Set the possible repeat days
    let daysInPt: [String] = ([ "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado", "Domingo"])
    
    ///Interact with Weeks model
    var weekDays: Weeks!
    
    //tracker - Google Analytics
    let tracker = GAI.sharedInstance().trackerWithTrackingId("UA-70701653-1")
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationTitle.title = NSLocalizedString("Repetir", comment: "")
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        //Google Analytics - monitoring screens
        tracker.set(kGAIScreenName, value: "Selection Weeks")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
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
        //Google Analytics - monitoring events - dicover created food
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("Weeks", action: "See the day of week selected or deselected", label: cell?.textLabel?.text , value: (cell!.accessoryType == .Checkmark)).build() as [NSObject : AnyObject])
        
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
            destinationViewController.mealWeekDays = self.weekDays
        }
    }
    
}
