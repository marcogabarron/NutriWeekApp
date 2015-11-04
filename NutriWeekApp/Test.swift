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

class TestController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var simpleDraw: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.mealImage.layer.masksToBounds = true
        self.simpleDraw.layer.masksToBounds = true
        self.simpleDraw.layer.borderWidth = 1
        self.simpleDraw.layer.cornerRadius = self.simpleDraw.frame.height/8
        
        self.simpleDraw.layer.borderColor = UIColor.grayColor().CGColor
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
            }
        }
        ))
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            
        }
        
        refreshAlert.addAction(cancelAction)
        
        presentViewController(refreshAlert, animated: true, completion: nil)
        
        
        
        


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
