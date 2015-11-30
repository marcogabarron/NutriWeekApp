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
import Photos

class AddDailyVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UIGestureRecognizerDelegate {
    
    //MARK: IBOutlets and other variables and constants
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var bottomDP: NSLayoutConstraint!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var hour: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var switchDiet: UISwitch!
    @IBOutlet weak var heightImage: NSLayoutConstraint!
    @IBOutlet weak var heightView: NSLayoutConstraint!
    
    //Relative to models and CoreData
    let dateFormatter = NSDateFormatter()
    //Relative to save images
    var fileManager = NSFileManager.defaultManager()
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    
    var date: NSDate!
    ///Verify if the choiced image was taked by the user and allows it to be saved
    var newMedia: Bool?
    
    ///tracker and builder - Google Analytics
    let tracker = GAI.sharedInstance().trackerWithTrackingId("UA-70701653-1")
    let builder = GAIDictionaryBuilder.createScreenView()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mealImage.hidden = true
        
        self.saveButton.title = NSLocalizedString("", comment: "")
        self.saveButton.enabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        //Google Analytics - monitoring screens
        tracker.set(kGAIScreenName, value: "Created daily")
        
        tracker.send(builder.build() as [NSObject : AnyObject])
        
        // Set current date and time on labels and datePicker
        self.datePicker.date = NSDate()
        
        self.dateLabel.text = self.dateFormatter.formatDateToYearDateString(date)
        self.hour.setTitle(self.dateFormatter.formatDateToString(self.datePicker.date), forState: .Normal)
        
        descriptionText.delegate = self
        descriptionText!.autocorrectionType = UITextAutocorrectionType.No
        

        if(DailyServices.allDaily().count > 0){
            fileManager.fileExistsAtPath(paths)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Add a tiny line separator
        let topBorder = UIView()
        topBorder.backgroundColor = UIColor(red: 54/255, green: 145/255, blue: 92/255, alpha: 1)
        topBorder.frame = CGRect(x: 0, y: 0, width: self.mealImage.frame.width, height: 1)
        self.container.addSubview(topBorder)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
        //Google Analytics - monitoring end
        builder.set(kGAISessionControl, forKey: "end")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK - Actions
    
    @IBAction func cameraButton(sender: AnyObject) {
        
        //Faz o alert que vai dar as opções de câmera e de galeria
        let alertCamera = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alertCamera.addAction(UIAlertAction(title: "Tirar Foto", style: .Default, handler: { (action: UIAlertAction!) in
            
            let authStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
            
            //Verifica a permissão da câmera
            if authStatus ==  AVAuthorizationStatus.Authorized
            {
                self.showCamera()
            }
            else if authStatus == AVAuthorizationStatus.Denied //Caso a câmera não esteja disponível, nas configurações, o usuário pode alterar
            {
                self.showAdjustmentDisclaimer("Câmera indisponível", message: "Vá em ajustes e altere as configurações do aplicativo para usar a câmera")
            }
            else if authStatus == AVAuthorizationStatus.NotDetermined {
                AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { granted in
                    if granted {
                        self.showCamera()
                    }
                    else {
                        self.showAdjustmentDisclaimer("Câmera indisponível", message: "Vá em ajustes e altere as configurações do aplicativo para usar a câmera")
                    }
                })
            }
        }))
        
        alertCamera.addAction(UIAlertAction(title: "Galeria", style: .Default, handler: { (action: UIAlertAction!) in
            
            //Chamar galeria
            
            let authStatus = PHPhotoLibrary.authorizationStatus()
            
            if authStatus == PHAuthorizationStatus.Authorized {
                self.showGalleryPicker()
            }
            else if authStatus == PHAuthorizationStatus.Denied {
                self.showAdjustmentDisclaimer("Galeria indisponível", message: "Vá em ajustes e altere as configurações do aplicativo para usar a galeria")
            }
            else if authStatus == PHAuthorizationStatus.NotDetermined {
                PHPhotoLibrary.requestAuthorization({status in
                    if authStatus == PHAuthorizationStatus.Authorized {
                        self.showGalleryPicker()
                    }
                    else if authStatus == PHAuthorizationStatus.Denied {
                        self.showAdjustmentDisclaimer("Galeria indisponível", message: "Vá em ajustes e altere as configurações do aplicativo para usar a galeria")
                    }
                })
            }
        }))
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
        }
        alertCamera.addAction(cancelAction)
        
        presentViewController(alertCamera, animated: true, completion: nil)
        
    }
    
    func showCamera() {
        //Google Analytics - monitoring events - dicover created food
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("Button Camera", action: "showCamera", label: "Camera", value: nil).build() as [NSObject : AnyObject])
        
        
        //Chamar câmera
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            //                    imagePicker.allowsEditing = true
            imagePicker.showsCameraControls = true
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
            self.newMedia = true
        }
    }
    
    func showGalleryPicker() {
        //Google Analytics - monitoring events - dicover created food
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("Button Camera", action: "showGallery", label: "Gallery", value: nil).build() as [NSObject : AnyObject])
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.allowsEditing = true
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
        self.newMedia = false
    }
    
    func showAdjustmentDisclaimer(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
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
    
    @IBAction func saveButton(sender: AnyObject) {
        if(self.descriptionText.text == "No que você está pensando"){
            self.descriptionText.text = ""
        }
        
        //Google Analytics - monitoring events - dicover created food
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("Button Save", action: "Save daily - we want to see if the user writes the description and if he fled diet", label: self.descriptionText.text, value: self.switchDiet.on).build() as [NSObject : AnyObject])
        
        let dateDay = dateFormatter.formatDateToDateString(date)

        let hourDatePicker = dateFormatter.formatDateToStringWithSecounds(self.datePicker.date)
        
        let dateString = dateDay + " " + hourDatePicker
        
        let finalDate = dateFormatter.formatCompleteStringToDate(dateString)
        

        let daily: DailyModel = DailyModel(date: finalDate, fled: self.switchDiet.on, desc: self.descriptionText.text)
        
        if(self.mealImage.hidden == false){
            let id = Int(date.timeIntervalSince1970 * 1000)
            
            let selectedImage = mealImage.image
            let imageData: NSData = UIImagePNGRepresentation(selectedImage!)!
            let filePathToWrite = "\(paths)/\(id).png"
            
            daily.setImage(("\(paths)/\(id).png"))
            fileManager.createFileAtPath(filePathToWrite, contents: imageData, attributes: nil)
            self.mealImage.image = UIImage(named: filePathToWrite)
        }

        DailyServices.createDaily(daily.date, fled: daily.fled, description: daily.descriptionStr, hasImage: daily.hasImage!, name: daily.nameImage!)
        self.navigationController?.popViewControllerAnimated(true)

    }
    
    
    @IBAction func datePickerAppear(sender: AnyObject) {
        self.datePicker.date = self.dateFormatter.formatStringToDate((self.hour.titleLabel?.text)!)
        
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
        self.addSaveButton()
        
        self.hour.setTitle( self.dateFormatter.formatDateToString(self.datePicker.date), forState: .Normal)
    }
    
    
    @IBAction func fletChange(sender: AnyObject) {
        self.addSaveButton()
    }

    
    //MARK - logical functions associated to Datepicker
    
    //Gesture tap to close datepicker
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if(self.bottomDP.constant == -216){
            return false
            
        }
        return true
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
    
    
    //MARK - logical functions associated to TextView
    
    override func becomeFirstResponder() -> Bool {
        self.descriptionText.text = "No que você está pensando"
        self.descriptionText.textColor = UIColor.lightGrayColor()
        
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if (descriptionText?.text == "No que você está pensando") {
            
            self.addSaveButton()
            descriptionText!.text = nil
            descriptionText!.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if descriptionText!.text.isEmpty {
            
            descriptionText!.text = "No que você está pensando"
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
    
    
    //MARK - logical functions associated to Image and save button
    
    func addSaveButton(){
        self.saveButton.title = NSLocalizedString("Salvar", comment: "Salvar")
        self.saveButton.enabled = true
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        var originalImage:UIImage?, editedImage:UIImage?, imageToSave:UIImage?
        
        
        let compResult:CFComparisonResult = CFStringCompare(mediaType as NSString!, kUTTypeImage, CFStringCompareFlags.CompareCaseInsensitive)
        if ( compResult == CFComparisonResult.CompareEqualTo ) {
            self.addSaveButton()
            
            editedImage = info[UIImagePickerControllerEditedImage] as! UIImage?
            originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage?
            
            if ( editedImage != nil ) {
                imageToSave = editedImage
            } else {
                imageToSave = originalImage
            }
            
            if imageToSave?.imageOrientation == .Down {
                imageToSave = imageToSave?.rotate(CGFloat(M_PI), flip: false, invertSize: false)
            }
            else if imageToSave?.imageOrientation == .Left {
                imageToSave = imageToSave?.rotate(CGFloat(-M_PI_2), flip: false, invertSize: true)
            }
            else if imageToSave?.imageOrientation == .Right {
                imageToSave = imageToSave?.rotate(CGFloat(M_PI_2), flip: false, invertSize: true)
            }
            
            let imageHeightProportion = imageToSave!.size.width / self.mealImage.frame.width
            let imageHeight = imageToSave!.size.height / imageHeightProportion
            
            self.mealImage.hidden = false
            self.mealImage.frame = CGRect(x: 0, y: 0, width: self.mealImage.frame.width, height: imageHeight)
            
            if (newMedia == true) {
                
                //UIImageWriteToSavedPhotosAlbum(imageToSave!, self,"image:didFinishSavingWithError:contextInfo:", nil)
            }
            
            self.mealImage.image = imageToSave
            // Image height + Initial Value (170)
            self.heightView.constant = 170 + imageHeight
            // Image Height
            self.heightImage.constant = imageHeight
            
            self.mealImage.setNeedsDisplay()
            
            
        }
        
         self.dismissViewControllerAnimated(true, completion: nil)
        

    }
    
}
