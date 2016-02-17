//
//  ConnectVC.swift
//  NutriWeekApp
//
//  Created by Jessica Oliveira on 28/01/16.
//  Copyright © 2016 Gabarron. All rights reserved.
//

import UIKit

class ConnectVC: UIViewController, UITextFieldDelegate {
    
    var kbHeight: CGFloat!

    @IBOutlet weak var connectTxt: UITextField!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var soonButton: UIButton!
    @IBOutlet weak var desconnectButton: UIButton!
    @IBOutlet weak var nutritionisttext: UINavigationItem!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        
        self.textLabel.text = NSLocalizedString("Seu Nutricionista faz parte da rede NutriWeek? Caso seja insira o código enviado ao seu email. ", comment: "")
        
        self.soonButton.setTitle( NSLocalizedString("Conectar", comment: ""), forState: .Normal)
        self.desconnectButton.setTitle( NSLocalizedString("Desconectar", comment: ""), forState: .Normal)
        
        self.nutritionisttext.title = NSLocalizedString("Nutricionista", comment: "")

        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func dismissKeyboard(){
        //textField.resignFirstResponder()
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                kbHeight = keyboardSize.height
                self.animateTextField(true)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.animateTextField(false)
    }
    
    func animateTextField(up: Bool) {
        let movement = (up ? -kbHeight : kbHeight)
        
        UIView.animateWithDuration(0.3, animations: {
            self.view.frame = CGRectOffset(self.view.frame, 0, movement)
        })
    }
    
//    @IBAction func signinTapped(sender : UIButton) {
//        var password:NSString = connectTxt.text!
//        
//        if (password.isEqualToString("") ) {
//            
//            var alertView:UIAlertView = UIAlertView()
//            alertView.title = "Sign in Failed!"
//            alertView.message = "Please enter Username and Password"
//            alertView.delegate = self
//            alertView.addButtonWithTitle("OK")
//            alertView.show()
//        } else {
//            
//            var post:NSString = "password=\(password)"
//            
//            NSLog("PostData: %@",post);
//            
//            var url:NSURL = NSURL(string: "https://dipinkrishna.com/jsonlogin2.php")!
//            
//            var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
//            
//            var postLength:NSString = String( postData.length )
//            
//            var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
//            request.HTTPMethod = "POST"
//            request.HTTPBody = postData
//            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
//            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//            request.setValue("application/json", forHTTPHeaderField: "Accept")
//            
//            
//            var reponseError: NSError?
//            var response: NSURLResponse?
//            
//            var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
//            
//            if ( urlData != nil ) {
//                let res = response as! NSHTTPURLResponse!;
//                
//                NSLog("Response code: %ld", res.statusCode);
//                
//                if (res.statusCode >= 200 && res.statusCode < 300)
//                {
//                    var responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
//                    
//                    NSLog("Response ==> %@", responseData);
//                    
//                    var error: NSError?
//                    
//                    let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers , error: &error) as NSDictionary
//                    
//                    
//                    let success:NSInteger = jsonData.valueForKey("success") as! NSInteger
//                    
//                    //[jsonData[@"success"] integerValue];
//                    
//                    NSLog("Success: %ld", success);
//                    
//                    if(success == 1)
//                    {
//                        NSLog("Login SUCCESS");
//                        
//                        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
////                        prefs.setObject(username, forKey: "USERNAME")
//                        prefs.setInteger(1, forKey: "ISLOGGEDIN")
//                        prefs.synchronize()
//                        
//                        self.dismissViewControllerAnimated(true, completion: nil)
//                    } else {
//                        var error_msg:NSString
//                        
//                        if jsonData["error_message"] as? NSString != nil {
//                            error_msg = jsonData["error_message"] as! NSString
//                        } else {
//                            error_msg = "Unknown Error"
//                        }
//                        var alertView:UIAlertView = UIAlertView()
//                        alertView.title = "Sign in Failed!"
//                        alertView.message = error_msg as String
//                        alertView.delegate = self
//                        alertView.addButtonWithTitle("OK")
//                        alertView.show()
//                        
//                    }
//                    
//                } else {
//                    var alertView:UIAlertView = UIAlertView()
//                    alertView.title = "Sign in Failed!"
//                    alertView.message = "Connection Failed"
//                    alertView.delegate = self
//                    alertView.addButtonWithTitle("OK")
//                    alertView.show()
//                }
//            } else {
//                var alertView:UIAlertView = UIAlertView()
//                alertView.title = "Sign in Failed!"
//                alertView.message = "Connection Failure"
//                if let error = reponseError {
//                    alertView.message = (error.localizedDescription)
//                }
//                alertView.delegate = self
//                alertView.addButtonWithTitle("OK")
//                alertView.show()
//            }
//        }
//    
//        
//    }
    
//    @IBAction func logoutTapped(sender : UIButton) {
//        
//        let appDomain = NSBundle.mainBundle().bundleIdentifier
//        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
//        
//        self.performSegueWithIdentifier("goto_login", sender: self)
//    }

    
}
