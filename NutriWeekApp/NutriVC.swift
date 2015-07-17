
import UIKit
import CoreData

class NutriVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var diasDaSemana: UILabel!
    
    //Relative to tableview
    @IBOutlet weak var tableView: UITableView!
    var diasSemana: [String]!
    var diasPT: [String] = ["Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado"]
    let ReuseIdentifier: String = "ReuseIdentifier"
    
    //Relative to models and CoreData
    var items: [Refeicao]!
    var json = ReadJson()
    var alimento = Alimentos()
    var notification = Notifications()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        diasSemana = []
        for dia in  self.diasPT{
            diasSemana.append(NSLocalizedString(dia, comment: ""))
        }
        
        diasDaSemana.text = NSLocalizedString("Dias da Semana", comment: "")
        
        //Load json in CoreData
        json.loadFeed()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()

    }
    
    
    //MARK: TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        self.items = RefeicaoServices.findByWeek(self.diasPT[section])
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
        self.items = RefeicaoServices.findByWeek(self.diasPT[indexPath.section])
    
        if(self.items.count > 0){
            cell.textLabel!.text = self.items[indexPath.row].name
            cell.detailTextLabel?.text = notification.formatStringTime(self.items[indexPath.row].horario)
            
        }

        return cell
    
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor(red: 40/255, green: 150/255, blue: 120/255, alpha: 1)
        
        var label: UILabel = UILabel(frame: CGRect(x: 37, y: 0, width: 300, height: 30))
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.text = NSLocalizedString(self.diasSemana[section], comment: "")
        label.font = UIFont(name:"AmericanTypewriter-Bold", size: 22)
        headerView.addSubview(label)
        
        self.items = RefeicaoServices.findByWeek(self.diasSemana[section])
        
        return headerView
    }
    
    
    //MARK - Table View - Deletion and action buttons
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            //Read the sections and all refeicao inside
            self.items = RefeicaoServices.findByWeek(self.diasSemana[indexPath.section])
            
            //Delete Refeicao
            RefeicaoServices.deleteRefeicaoByUuid(self.items[indexPath.row].uuid)
            
            //Delete Notification
            let date = NSDate()
            let todoItem = TodoItem(deadline: date, title: self.items[indexPath.row].name , UUID: self.items[indexPath.row].uuid )
            TodoList.sharedInstance.removeItem(todoItem)
            
            //Delete row
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
        }
    }
    
    
    //MARK - Prepare for segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "selected") {
            let destinationViewController = segue.destinationViewController as! CollectionVC
            var refeicao: Refeicao = RefeicaoServices.findByName(sender!.textLabel!!.text!)
            destinationViewController.refeicaoID = refeicao.uuid
        }
    }

}

