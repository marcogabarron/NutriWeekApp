

import UIKit
import CoreData

class CreateItemVC: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var libraryPicButton: UIButton!
    
    @IBOutlet weak var takePicButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameTextField.delegate = self
        
        //Setting a border for libraryPic button
        libraryPicButton.backgroundColor = UIColor.clearColor()
        libraryPicButton.layer.cornerRadius = 5
        libraryPicButton.layer.borderColor = UIColor(red: 40/255, green: 150/255, blue: 120/255, alpha: 1).CGColor
        libraryPicButton.layer.borderWidth = 1
        
        //Setting a border for TakePic button
        takePicButton.backgroundColor = UIColor.clearColor()
        takePicButton.layer.cornerRadius = 5
        takePicButton.layer.borderColor = UIColor(red: 40/255, green: 150/255, blue: 120/255, alpha: 1).CGColor
        takePicButton.layer.borderWidth = 1
        
        //Setting a border for Cancel button
        cancelButton.backgroundColor = UIColor.clearColor()
        cancelButton.layer.cornerRadius = 5
        cancelButton.layer.borderColor = UIColor(red: 40/255, green: 150/255, blue: 120/255, alpha: 1).CGColor
        cancelButton.layer.borderWidth = 1
        
    }
    
    
    
    func textFieldShouldReturn(nameTextField: UITextField) -> Bool {
        
        nameTextField.resignFirstResponder()
        
        return true
        
    }
    
    
    
    
    
}
