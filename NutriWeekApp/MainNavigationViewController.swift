//
//  MainNavigationViewController.swift
//  NutriWeekApp
//
//  Created by Gabarron on 31/07/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.
//

import UIKit

class MainNavigationViewController: UINavigationController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        
        //if viewController.isKindOfClass(TutorialVC) {
            
            // Initiliaze NSUserDefaults default values
            //NSUserDefaults.standardUserDefaults().registerDefaults(["FirstLaunch" : true])
            
            let firstLaunch = NSUserDefaults.standardUserDefaults().boolForKey("FirstLaunch")
            if firstLaunch  {
                println("é a primeira vez que o app é rodado")
//                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "FirstLaunch")
//                NSUserDefaults.standardUserDefaults().synchronize()
                      performSegueWithIdentifier("tutorial", sender: nil)
              
            } else {
                //self.performSegueWithIdentifier("start", sender: self)
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "FirstLaunch")
                NSUserDefaults.standardUserDefaults().synchronize()
                dismissViewControllerAnimated(false, completion: nil)
            
            }
        }
   // }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
