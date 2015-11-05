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
import AVFoundation
import AssetsLibrary

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
                //Caso a câmera não esteja disponível, nas configurações, o usuário pode alterar
            }
            else
            {
                
                let alert = UIAlertController(title: "Câmera indisponível", message: "Vá em ajustes e altere as configurações do aplicativo para usar a câmera", preferredStyle: UIAlertControllerStyle.ActionSheet)
                
                alert.addAction(UIAlertAction(title: "Ir para ajustes", style: .Default, handler: { (action: UIAlertAction!) in
                    //Direcionar para ajustes
                    
                    let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
                    if let url = settingsUrl {
                        UIApplication.sharedApplication().openURL(url)
                    }
                    
                }))
                
                alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Cancel, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
        }))
        
        alertCamera.addAction(UIAlertAction(title: "Galeria", style: .Default, handler: { (action: UIAlertAction!) in
            
            
            //Chamar galeria
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum) {
                
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = true
                
                self.presentViewController(imagePicker, animated: true, completion: nil)
              //  self.newMedia = false
            }
            
                //Caso a galeria não esteja disponível, nas configurações, o usuário pode alterar
            else {
                
                let alert = UIAlertController(title: "Galeria indisponível", message: "Vá em ajustes e altere as configurações do aplicativo para usar a galeria", preferredStyle: UIAlertControllerStyle.ActionSheet)
                
                alert.addAction(UIAlertAction(title: "Ir para ajustes", style: .Default, handler: { (action: UIAlertAction!) in
                   //Direcionar para ajustes
                    
                    let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
                    if let url = settingsUrl {
                        UIApplication.sharedApplication().openURL(url)
                    }
                    
                }))
                
                alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Cancel, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
        }))
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
        }
        alertCamera.addAction(cancelAction)
        
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
    
    
    @IBAction func saveButton(sender: AnyObject) {
        
//        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as String!
        // self.fileName is whatever the filename that you need to append to base directory here.
        //        let path = documentsDirectory.stringByAppendingPathComponent(descriptionText.text)
        //
        //        let success = data.writeToFile(path, atomically: true)
//        if !success { // handle error }
//        }
        
    }
    
    
    /** Faz o controle das ações já realizadas pela câmera. Nesse caso, salva a fotografia no Imave View, considerando a edição da fotografia, caso aconteça **/
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        var originalImage:UIImage?, editedImage:UIImage?, imageToSave:UIImage?
        
        
        if mediaType.isEqual(kUTTypeImage as String) {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            self.mealImage.hidden = false
            self.mealImage.image = image
            self.mealImage.frame = CGRect(x: 0, y: 0, width: 100, height: 200)

            
            editedImage = info[UIImagePickerControllerEditedImage] as! UIImage?
            originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage?
            
            if ( editedImage != nil ) {
                imageToSave = editedImage
            } else {
                imageToSave = originalImage
            }
            mealImage.image = imageToSave
            mealImage.reloadInputViews()
            
        }
        
         self.dismissViewControllerAnimated(true, completion: nil)
        
        
//        if mediaType.isEqual(kUTTypeImage as String) {
//            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//            
//            mealImage.image = image
//            
//            
////            let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as String!
//            // self.fileName is whatever the filename that you need to append to base directory here.
////            let path = documentsDirectory.stringByAppendingPathComponent(self.mealImage)
//            
//            
////            if (newMedia == true) {
////                
////                UIImageWriteToSavedPhotosAlbum(image, self,"image:didFinishSavingWithError:contextInfo:", nil)
////                
////            } else if mediaType.isEqual(kUTTypeMovie as String) {
////                // Code to support video here
////            }
//            
//        }
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
