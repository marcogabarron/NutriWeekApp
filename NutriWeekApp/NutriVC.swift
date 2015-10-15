
import UIKit
import CoreData

class NutriVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var diasDaSemana: UILabel!
    @IBOutlet weak var newMeal: UIButton!
    
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
        
      
        
        //collor image Button
        self.newMeal.imageView!.tintColor = UIColor(red: 40/255, green: 150/255, blue: 120/255, alpha: 0.89)
        self.diasSemana = []
        
        //translate the weekdays
        for dia in  self.diasPT{
            self.diasSemana.append(NSLocalizedString(dia, comment: ""))
        }
        
        //translate the label
        self.diasDaSemana.text = NSLocalizedString("Dias da Semana", comment: "")
        
        //Load json in CoreData
        self.json.loadFeed()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    
    //MARK: TableView
    //the TableView is used to show the meals from each weekday. It is used to show the name and the notification hour.
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //here passed the items from same week and count
        self.items = RefeicaoServices.findByWeek(self.diasPT[section])
        return items.count
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //here is number of sections - seven
        return self.diasSemana.count
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
        
    }
    
    
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("ReuseIdentifier", forIndexPath: indexPath)
        self.items = RefeicaoServices.findByWeek(self.diasPT[indexPath.section])
    
        //verify if there is any item in this weekday
        if(self.items.count > 0){
            
            cell.textLabel!.text = self.items[indexPath.row].name
            cell.detailTextLabel?.text = notification.formatStringTime(self.items[indexPath.row].horario)
            
        }

        return cell
    
    }
    
    //configure the layout of section
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor(red: 40/255, green: 150/255, blue: 120/255, alpha: 1)
        
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        label.autoresizesSubviews = true
        label.minimumScaleFactor = 0.5
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
        label.text = NSLocalizedString(self.diasSemana[section], comment: "")
        label.font = UIFont(name:"AmericanTypewriter-Bold", size: 22)
        headerView.addSubview(label)
        
        self.items = RefeicaoServices.findByWeek(self.diasSemana[section])
        
        return headerView
    }
    
    
    //MARK - Table View - Deletion and action buttons
    //delete cell and data in the Core Data
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
    /** Prepare for Segue to CollectionVC page -- pass the uuid information from cell clicked  **/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "selected") {
            let destinationViewController = segue.destinationViewController as! CollectionVC
            let refeicao: Refeicao = RefeicaoServices.findByName(sender!.textLabel!!.text!)
            destinationViewController.refeicaoID = refeicao.uuid
        }
    }

}

