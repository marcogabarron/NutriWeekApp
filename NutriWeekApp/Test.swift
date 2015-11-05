//
//  Test.swift
//  NutriWeekApp
//
//  Created by Vítor Machado Rocha on 04/11/15.
//  Copyright © 2015 Gabarron. All rights reserved.
//
import Foundation
import UIKit
import MobileCoreServices

class TestController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var simpleDraw: UIImageView!
    @IBOutlet weak var bottomDP: NSLayoutConstraint!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var hour: UIButton!
    
    var date: NSDate = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.mealImage.hidden = true

    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.datePicker.date = date
        
        self.hour.setTitle( timePicker(self.datePicker), forState: .Normal)
        
        self.simpleDraw.layer.masksToBounds = true
        self.simpleDraw.layer.borderWidth = 1
        self.simpleDraw.layer.cornerRadius = self.simpleDraw.frame.height*0.05
        self.simpleDraw.layer.borderColor = UIColor.grayColor().CGColor
        
        
        descriptionText.delegate = self
        descriptionText!.autocorrectionType = UITextAutocorrectionType.No
        
        //tap to close keyboard and close date picker
        let tap = UITapGestureRecognizer(target: self, action: "closeDatePicker:")
        tap.numberOfTapsRequired = 1
        tap.delegate = self
        self.view.addGestureRecognizer(tap)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func cameraButton(sender: AnyObject) {
        
        let refreshAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        refreshAlert.addAction(UIAlertAction(title: "Tirar Foto", style: .Default, handler: { (action: UIAlertAction!) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = true
                imagePicker.showsCameraControls = true
                
                self.presentViewController(imagePicker, animated: true, completion: nil)
               // self.newMedia = true
                
            }
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Galeria", style: .Default, handler: { (action: UIAlertAction!) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum) {
                
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = true
                
                self.presentViewController(imagePicker, animated: true, completion: nil)
              //  self.newMedia = false
            }
        }
        ))
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            
        }
        
        refreshAlert.addAction(cancelAction)
        
        presentViewController(refreshAlert, animated: true, completion: nil)


    }
    
    @IBAction func datePickerAppear(sender: AnyObject) {
        self.datePicker.date = self.formatTime((self.hour.titleLabel?.text)!)
        
        if(self.bottomDP.constant == -216){
            
            self.view.layoutIfNeeded()
            UIView.animateWithDuration(1, animations: {
                self.bottomDP.constant = 0
                self.view.layoutIfNeeded()
            })
            
        }else{
            self.view.layoutIfNeeded()
            UIView.animateWithDuration(1, animations: {
                self.bottomDP.constant = -216
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func UpdateTimerPicker(sender: AnyObject) {
            self.hour.setTitle( timePicker(self.datePicker), forState: .Normal)
        
    }
    
    func closeDatePicker(){
        if(self.bottomDP.constant != -216){
            self.view.layoutIfNeeded()
            UIView.animateWithDuration(1, animations: {
                self.bottomDP.constant = -216
                self.view.layoutIfNeeded()
            })
        }
    }
    
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if(self.bottomDP.constant == -216){
            return false
            
        }
        return true
        
    }
    
    /** Get datePicker and returns a string formatted to save Refeicao **/
    func timePicker(sender: UIDatePicker) -> String{
        
        let timer = NSDateFormatter()
        timer.dateFormat = "HH:mm"
        
        let strdate = timer.stringFromDate(sender.date)
        
        return strdate
        
    }
    
    /** Convert stringDate to Date **/
    func formatTime(dataString: String) -> NSDate{
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        
        let dateValue = dateFormatter.dateFromString(dataString)
        
        return dateValue!
        
    }
    
    override func becomeFirstResponder() -> Bool {
        self.descriptionText.text = "Escreva uma descrição ou comentário"
        self.descriptionText.textColor = UIColor.lightGrayColor()
        
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if (descriptionText?.text == "Escreva uma descrição ou comentário")
            
        {
            descriptionText!.text = nil
            descriptionText!.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if descriptionText!.text.isEmpty
        {
            descriptionText!.text = "Escreva uma descrição ou comentário"
            descriptionText!.textColor = UIColor.lightGrayColor()
        }
        textView.resignFirstResponder()
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if mediaType.isEqual(kUTTypeImage as String) {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            self.mealImage.hidden = false
            self.mealImage.image = image
            self.mealImage.frame = CGRect(x: 0, y: 0, width: 100, height: 200)

            
            
//            let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as String!
            // self.fileName is whatever the filename that you need to append to base directory here.
//            let path = documentsDirectory.stringByAppendingPathComponent(self.mealImage)
            
            
//            if (newMedia == true) {
//                
//                UIImageWriteToSavedPhotosAlbum(image, self,"image:didFinishSavingWithError:contextInfo:", nil)
//                
//            } else if mediaType.isEqual(kUTTypeMovie as String) {
//                // Code to support video here
//            }
            
        }
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
