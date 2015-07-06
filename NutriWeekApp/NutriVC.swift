
import UIKit
import CoreData

class NutriVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    var diasSemana = ["Segunda-Feira", "Terça-Feira", "Quarta-Feira", "Quinta-Feira", "Sexta-Feira", "Sábado", "Domingo"]
    let ReuseIdentifier: String = "ReuseIdentifier"
    var items: [ItemCardapio]!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.

    }
    

    @IBAction func AddItemButton(sender: UIButton) {
        
//        var alert = UIAlertController(title: "New Item",
//            message: "Add a new Item",
//            preferredStyle: .Alert)
//        
//        let destroyAction = UIAlertAction(title: "Destroy", style: .Destructive) { (action) in
//            println("destroi a opcao selecionada")
//            
//        }
//        
//        let saveAction = UIAlertAction(title: "Save",
//            style: .Default) { (action: UIAlertAction!) -> Void in
//                
//                let textField = alert.textFields![0] as! UITextField
//                
//                // create new ItemCardapio
//                ItemCardapioServices.createItemCardapio(textField.text)
//                self.items = ItemCardapioServices.allItemCardapios()
//                self.tableView.reloadData()
//                
//        }
//        
//        let cancelAction = UIAlertAction(title: "Cancel",
//            style: .Default) { (action: UIAlertAction!) -> Void in
//        }
//        
//        alert.addTextFieldWithConfigurationHandler {
//            (textField: UITextField!) -> Void in
//        }
//        
//        alert.addAction(saveAction)
//        alert.addAction(cancelAction)
//        
//        presentViewController(alert,
//            animated: true,
//            completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        items = ItemCardapioServices.allItemCardapios()
        self.tableView.reloadData()

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return items.count
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return diasSemana.count
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 45
        
    }
    
    
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("ReuseIdentifier") as! UITableViewCell
    
        cell.textLabel!.text = items[indexPath.row].name
    
        return cell
    
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor(red: 40/255, green: 150/255, blue: 120/255, alpha: 1)
        
        var label: UILabel = UILabel(frame: CGRect(x: 42, y: 0, width: 300, height: 50))
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.text = diasSemana[section]
        label.font = UIFont(name:"AmericanTypewriter-Bold", size: 30)
        headerView.addSubview(label)
        
        return headerView
        
    }

}

