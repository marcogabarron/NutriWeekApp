

import UIKit
import CoreData

class CreateItemVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var imageCategory: UIImageView!
    
    @IBOutlet weak var labelName: UILabel!
    
    
    var categoryArray:[String] = [String]()
    
    var selectedCategory:String = ""
    
    var numberCategory: Int = 0
    
    var saveClicked: Bool!
    
    override func viewWillDisappear(animated: Bool) {
        
        if self.navigationController?.viewControllers.indexOf(self) == nil && !saveClicked {
            
            let alert = UIAlertView(title: "Take one option", message: "Really want to go back", delegate: nil, cancelButtonTitle: "Cancel")
            alert.show()
            
        
            //UIAlert para perguntar se ele deseja salvar somente para este dia ou para todos os dias
//            let alert = UIAlertController(title: "Take one option",
//                message: "Really want to go back?",
//                preferredStyle: .Alert)
//            
//            let save = UIAlertAction(title: "Save modifications",
//                style: .Default) { (action: UIAlertAction!) -> Void in
//            }
//            
//            let cancel = UIAlertAction(title: "Cancel",
//                style: .Default) { (action: UIAlertAction!) -> Void in
//                    
//            }
//            
//            alert.addAction(save)
//            alert.addAction(cancel)
//        }
            
        }
        
        super.viewWillDisappear(animated)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillDisappear(animated)
        saveClicked = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.nameTextField.delegate = self
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        
        categoryArray = ["Pães e Massas", "Frutas", "Líquido", "Leite", "Feijão", "Ovo", "Legume", "Grão", "Frios", "Carne Branca", "Vegetais", "Carne Vermelha", "Arroz", "Água", "Café", "Molho", "Farofa", "Massa", "Soja"]
        
        imageCategory.layer.masksToBounds = true
        imageCategory.layer.cornerRadius = imageCategory.frame.width/6
        imageCategory.layer.borderWidth = 1
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return categoryArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return "\(categoryArray[row])"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedCategory = categoryArray[row]
        numberCategory = row + 1
        
        imageCategory.image = UIImage(named: "\(numberCategory)")
        
    }
    
    func textFieldShouldReturn(nameTextField: UITextField) -> Bool {
        
        nameTextField.resignFirstResponder()
        
        return true
        
    }
    
    @IBAction func nameChanged(){
        
        
        labelName.text = nameTextField.text
        
    }
    
    
    @IBAction func saveButtonClicked(sender: UIBarButtonItem) {
        saveClicked = true
        
        if nameTextField.text == ""{
            
            UIView.animateWithDuration(0.3, delay: 0.0, options: [], animations: {() -> Void in
                
                self.nameTextField.transform = CGAffineTransformMakeScale(1.2, 1.2)
                
                }, completion: {(result) -> Void in
                        UIView.animateWithDuration(0.3, animations: {() -> Void in
                
                self.nameTextField.transform = CGAffineTransformMakeScale(1.0, 1.0)
                self.nameTextField.text = ""
                self.nameTextField.placeholder = NSLocalizedString("*Choose a Name", comment: "")
                self.nameTextField.tintColor = UIColor.redColor()
                
                
            })
        })
        
        } else {
            //colocar função para criar item no core Data
            ItemCardapioServices.createItemCardapio(nameTextField.text!, image: "\(numberCategory)", category: selectedCategory)
                self.navigationController?.popViewControllerAnimated(true)
            
        }
    
}
    
}