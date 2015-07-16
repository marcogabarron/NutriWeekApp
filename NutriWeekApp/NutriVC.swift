
import UIKit
import CoreData

class NutriVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    var diasSemana = ["Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado", "Domingo"]
    let ReuseIdentifier: String = "ReuseIdentifier"
    
    var items: [Refeicao]!
    var json = ReadJson()
    var alimento = Alimentos()
    
    var notification = Notifications()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //To load json in Array
        json.loadFeed()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
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
            cell.detailTextLabel?.text = notification.formatTime(self.items[indexPath.row].horario)
            
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
    
    
    //MARK - Table View - Deletion and action buttons
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            self.items = RefeicaoServices.findByWeek(self.diasSemana[indexPath.section])
            
            RefeicaoServices.deleteRefeicaoByUuid(self.items[indexPath.row].uuid)
            
            //delete Notication
            let date = NSDate()
            let todoItem = TodoItem(deadline: date, title: self.items[indexPath.row].name , UUID: self.items[indexPath.row].uuid )
            TodoList.sharedInstance.removeItem(todoItem)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
        }
    }
    
    
    //MARK - Prepare for segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "selected") {
            let destinationViewController = segue.destinationViewController as! CollectionVC
            var refeicao: Refeicao = RefeicaoServices.findByName(sender!.textLabel!!.text!)
            destinationViewController.refeicaoID = refeicao.uuid
        }else{
            
        }
    }

}

