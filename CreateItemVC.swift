

import UIKit
import CoreData

//protocol CreateItemVCDelegate {
//    func willComeBackFromCreateItemVC(fromSave: Bool)
//   // func saveItemVC(name: String, image: String, category: String)
//}

class CreateItemVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    //MARK: IBOutlets and other variables and constants
    @IBOutlet weak var save: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var simpleLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var imageCategory: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    

    ///Relative to food category
    var categoryArray:[String] = [String]()
    var selectedCategory: String = ""
    var numberCategory: Int = 1
    
    ///builder and tracker - Google Analytics
    let tracker = GAI.sharedInstance().trackerWithTrackingId("UA-70701653-1")
    let builder = GAIDictionaryBuilder.createScreenView()

    
    //MARK: Lifecycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillDisappear(animated)
        //saveClicked = false
        self.navigationItem.title = NSLocalizedString("Novo Alimento", comment: "")
        self.save.title = NSLocalizedString("Concluir", comment: "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Google Analytics - monitoring screens
        tracker.set(kGAIScreenName, value: "Create Item")
        
        tracker.send(builder.build() as [NSObject : AnyObject])

        self.nameTextField.delegate = self
        self.nameTextField.placeholder = NSLocalizedString("Nome do Item", comment: "")
        
        self.labelName.text = NSLocalizedString("Nome do Item", comment: "")
        self.simpleLabel.text = NSLocalizedString("Selecione uma categoria:", comment: "")

        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        
        categoryArray = ["Pães e Massas", "Frutas", "Líquido", "Leite", "Feijão", "Ovo", "Legume", "Grão", "Frios", "Carne Branca", "Vegetais", "Carne Vermelha", "Arroz", "Água", "Café", "Molho", "Farofa", "Massa", "Soja"]
        
        imageCategory.layer.masksToBounds = true
        imageCategory.layer.cornerRadius = imageCategory.frame.width/6
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //delegate?.willComeBackFromCreateItemVC(saveClicked)
    }
    
    //MARK: Picker view
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let show = NSLocalizedString(self.categoryArray[row], comment: "")
        
        return show
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedCategory = categoryArray[row]
        numberCategory = row + 1
        
        imageCategory.image = UIImage(named: "\(numberCategory)")
        
    }
    
    
    //MARK: Actions
    
    /** Close keyboard when clicked return **/
    func textFieldShouldReturn(nameTextField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func onTapped(sender: AnyObject) {
        view.endEditing(true)
    }
    
    
    @IBAction func nameChanged(){
        labelName.text = nameTextField.text
    }
    
    
    @IBAction func saveButtonClicked() {
        //saveClicked = true
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
            let show = NSLocalizedString(self.selectedCategory, comment: "")
            let dataToAnalytic = self.nameTextField.text! + " " + self.selectedCategory
            
            //Google Analytics - monitoring events - dicover created food
            tracker.send(GAIDictionaryBuilder.createEventWithCategory("Button Save", action: "Created a food that was not registered before", label: dataToAnalytic, value: nil).build() as [NSObject : AnyObject])
            
            //colocar função para criar item no core Data
            ItemCardapioServices.createItemCardapio(nameTextField.text!, image: "\(numberCategory)" + ".jpg", category: show)
            
            self.navigationController?.popViewControllerAnimated(true)
            
        }
    }
}