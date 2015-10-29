//
//  CameraVC.swift
//  NutriWeekApp
//
//  Created by Vítor Machado Rocha on 19/10/15.
//  Copyright © 2015 Gabarron. All rights reserved.
//


import UIKit
import MobileCoreServices

class CameraVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var newImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = true
            imagePicker.showsCameraControls = true
            
            
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }

        
    }
    
    override func viewDidAppear(animated: Bool) {
        
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
//            
//            let imagePicker = UIImagePickerController()
//            
//            imagePicker.delegate = self
//            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
//            imagePicker.mediaTypes = [kUTTypeImage as String]
//            imagePicker.allowsEditing = true
//            imagePicker.showsCameraControls = true
//            
//            
//            
//            self.presentViewController(imagePicker, animated: true, completion: nil)
//        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if mediaType.isEqual(kUTTypeImage as String) {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            

            newImage = image
            
            
            
            
//            if (newMedia == true) {
//                
//                UIImageWriteToSavedPhotosAlbum(image, self,"image:didFinishSavingWithError:contextInfo:", nil)
//                
//            } else if mediaType.isEqual(kUTTypeMovie as String) {
//                // Code to support video here
//            }
            
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "taked") {
            
            
            let destinationViewController = segue.destinationViewController as! AddPhotoHistoryVC
            destinationViewController.newPhotoView.image = newImage!
            
        }
    }
    
 
}


