
import UIKit
import CoreData

class NutriVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    var diasSemana = ["Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado", "Domingo"]
    let ReuseIdentifier: String = "ReuseIdentifier"
    
    var items: [Refeicao]!
    var json = ReadJson()
    var alimento = Alimentos()
    var collectionview = CollectionVC()
    
    var notification = Notifications()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //To load json in Array
        json.loadFeed()
        
        
        
//        var date = NSDate()
//        let todoItem = TodoItem(deadline: date, title: "Teste", UUID: "B2FAB7FE-A98E-4B7F-9AAB-79260EEA8A4D")
//        TodoList.sharedInstance.removeItem(todoItem)
//        let todoItem2 = TodoItem(deadline: date, title: "Teste", UUID: "9D2E57CB-9AE6-4154-996E-7DF23DFC7E78")
//        TodoList.sharedInstance.removeItem(todoItem2)
        
        

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
        
        //items = RefeicaoServices.findByWeek("Sexta")
        
        self.tableView.reloadData()

    }
    
    //MARK: TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        self.items = RefeicaoServices.findByWeek(self.diasSemana[section])
        return items.count
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return diasSemana.count
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
        
    }
    
    
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("ReuseIdentifier") as! UITableViewCell
        self.items = RefeicaoServices.findByWeek(self.diasSemana[indexPath.section])
    
        if(self.items.count > 0){
            cell.textLabel!.text = self.items[indexPath.row].name
            cell.detailTextLabel?.text = self.formatTime(self.items[indexPath.row].horario)
        }

        return cell
    
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor(red: 40/255, green: 150/255, blue: 120/255, alpha: 1)
        
        var label: UILabel = UILabel(frame: CGRect(x: 37, y: 0, width: 300, height: 30))
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.text = self.diasSemana[section]
        label.font = UIFont(name:"AmericanTypewriter-Bold", size: 22)
        headerView.addSubview(label)
        
        self.items = RefeicaoServices.findByWeek(self.diasSemana[section])

        
        return headerView
        
    }
    
    //get string and returns a string formatted with local time zone
    func formatTime(dataString: String) -> String{
        
        var dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        
        let dateValue = dateFormatter.dateFromString(dataString)
        
        
        var stringFormatted = NSDateFormatter.localizedStringFromDate(dateValue!, dateStyle: .NoStyle, timeStyle: .ShortStyle)
        
        
        return stringFormatted
        
    }
    

    
    
    //MARK - Table View - Deletion and action buttons
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            self.items = RefeicaoServices.findByWeek(self.diasSemana[indexPath.section])
            
            RefeicaoServices.deleteRefeicaoByUuid(self.items[indexPath.row].uuid)
            
            let date = NSDate()
            let todoItem = TodoItem(deadline: date, title: self.items[indexPath.row].name , UUID: self.items[indexPath.row].uuid )
            TodoList.sharedInstance.removeItem(todoItem)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
        }
    }
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "selected") {
            let destinationViewController = segue.destinationViewController as! CollectionVC
            var refeicao: Refeicao = RefeicaoServices.findByName(sender!.textLabel!!.text!)
            destinationViewController.refeicao = refeicao
        }else{
            
        }
    }

}

