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

class TestController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var simpleDraw: UIImageView!

    
    let fileManager = NSFileManager.defaultManager()
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
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
        
        //Faz o alert que vai dar as opções de câmera e de galeria
        let alertCamera = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alertCamera.addAction(UIAlertAction(title: "Tirar Foto", style: .Default, handler: { (action: UIAlertAction!) in
            
            //Verifica a permissão da câmera
            if AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo) ==  AVAuthorizationStatus.Authorized
            {

            //Chamar câmera
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
        
        presentViewController(alertCamera, animated: true, completion: nil)

    }
    
    
    @IBAction func saveButton(sender: AnyObject) {
        
        let selectedImage = mealImage.image
        let filePathToWrite = "\(paths)\(descriptionText.text).png"
        let imageData: NSData = UIImagePNGRepresentation(selectedImage!)!
        
        fileManager.createFileAtPath(filePathToWrite, contents: imageData, attributes: nil)
        
//        let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
//        let nsUserDomainMask    = NSSearchPathDomainMask.UserDomainMask
//        let paths            = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
//        
//            if paths.count > 0
//            {
//                if let dirPath = paths[0] as String!
//                {
//                    let readPath = NSURL(fileURLWithPath: dirPath).URLByAppendingPathComponent(descriptionText.text) //dirPath.stringByAppendingPathComponent(descriptionText.text)
//                    let image    = UIImage(contentsOfFile: "\(readPath)")
//                    // Do whatever you want with the image
//                }
//            }
        
        
    }
    
    
    /** Faz o controle das ações já realizadas pela câmera. Nesse caso, salva a fotografia no Imave View, considerando a edição da fotografia, caso aconteça **/
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        var originalImage:UIImage?, editedImage:UIImage?, imageToSave:UIImage?
        
        
        let compResult:CFComparisonResult = CFStringCompare(mediaType as NSString!, kUTTypeImage, CFStringCompareFlags.CompareCaseInsensitive)
        if ( compResult == CFComparisonResult.CompareEqualTo ) {
            
            editedImage = info[UIImagePickerControllerEditedImage] as! UIImage?
            originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage?
            
            if ( editedImage != nil ) {
                imageToSave = editedImage
            } else {
                imageToSave = originalImage
            }
            
            UIImageWriteToSavedPhotosAlbum(imageToSave!, self,"image:didFinishSavingWithError:contextInfo:", nil)
            
            mealImage.image = imageToSave
            mealImage.reloadInputViews()
            
        }
        
         self.dismissViewControllerAnimated(true, completion: nil)
        
        
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
