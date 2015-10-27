
import UIKit
import CoreData

class NutriVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
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
        self.diasSemana = []
        
        //translate the weekdays
        for dia in  self.diasPT{
            self.diasSemana.append(NSLocalizedString(dia, comment: ""))
        }
      
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
        headerView.backgroundColor = UIColor(red: 51/255, green: 153/255, blue: 102/255, alpha: 1)
        
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        label.autoresizesSubviews = true
        label.minimumScaleFactor = 0.5
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
        label.text = NSLocalizedString(self.diasSemana[section], comment: "")
        label.font = UIFont(name:"Helvetica-SemiBold", size: 22)
        headerView.addSubview(label)
        
        self.items = RefeicaoServices.findByWeek(self.diasSemana[section])
        
        return headerView
    }
    
    
    //MARK - Table View - Deletion and action buttons
    //delete cell and data in the Core Data
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            //Read the sections and all refeicao inside
            self.items = RefeicaoServices.findByWeek(self.diasPT[indexPath.section])
            
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
            
            //let refeicao: Refeicao = RefeicaoServices.findByName(sender!.textLabel!!.text!)
            var refeicao:[Refeicao] = []
            var refID: String = ""
            let c = self.tableView.indexPathsForSelectedRows!.last?.section
            if(c==0){
                refeicao = RefeicaoServices.findByWeek("Domingo")
            }
            if(c==1){
                refeicao = RefeicaoServices.findByWeek("Segunda")
            }
            if(c==2){
                refeicao = RefeicaoServices.findByWeek("Terça")
            }
            if(c==3){
                refeicao = RefeicaoServices.findByWeek("Quarta")
            }
            if(c==4){
                refeicao = RefeicaoServices.findByWeek("Quinta")
            }
            if(c==5){
                refeicao = RefeicaoServices.findByWeek("Sexta")
            }
            if(c==6){
                refeicao = RefeicaoServices.findByWeek("Sábado")
            }
            var meal: Meal = Meal(week: [], time: "", name: "")
            for ref in refeicao {
                if(ref.name == (sender!.textLabel!!.text!)){
                    refID = ref.uuid
                    meal = Meal(id: ref.uuid, week: [ref.diaSemana], time: ref.horario, name: ref.name, foods: ref.getItemsObject())
                }
            }
            let destinationViewController = segue.destinationViewController as! CollectionVC
            destinationViewController.meal = meal
            
        }
    }

}

