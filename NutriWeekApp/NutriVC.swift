
import UIKit
import CoreData


class NutriVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    //MARK: IBOutlets and other variables and constants
    @IBOutlet weak var tableView: UITableView!
    
    ///Days for String for sections and go next page
    var daysInPt: [String] = ["Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado"]
    
    //Relative to models and CoreData
    var contextMeal: [Refeicao]!
    var format = NSDateFormatter()
    
    //tracker - Google Analytics
    let tracker = GAI.sharedInstance().trackerWithTrackingId("UA-70701653-1")
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstLaunch = NSUserDefaults.standardUserDefaults().boolForKey("FirstLaunch")
        if firstLaunch  {
        }
        else {
            let food = Food()
            //Load json in CoreData and set first launch has passed
            food.loadFeed()
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "FirstLaunch")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Google Analytics - monitoring screens
        tracker.set(kGAIScreenName, value: "NutriWeekVC")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        
        self.navigationItem.title = "Dieta"
        
        
        self.tableView.reloadData()
    }
    
    
    //MARK: TableView
    
    //The TableView is used to show the meals from each weekday. It is used to show the name and the notification hour.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //Verify and return the number of meals in each week
        return RefeicaoServices.findByWeek(self.daysInPt[section]).count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //Set the number of sections according with the number of days of week
        return self.daysInPt.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("ReuseIdentifier", forIndexPath: indexPath)
        self.contextMeal = RefeicaoServices.findByWeek(self.daysInPt[indexPath.section])

            cell.textLabel!.text = self.contextMeal[indexPath.row].name
            cell.detailTextLabel?.text = format.formatStringTime(self.contextMeal[indexPath.row].horario)
            

        return cell
    
    }
    
    //Configure the layout of section
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor(red: 212/255, green: 247/255, blue: 195/255, alpha: 1)
        
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        label.autoresizesSubviews = true
        label.minimumScaleFactor = 0.5
        label.textColor = UIColor(red: 60/255, green: 118/255, blue: 61/255, alpha: 1)
        label.textAlignment = NSTextAlignment.Center
        label.text = NSLocalizedString(self.daysInPt[section], comment: "")
        label.font = UIFont(name:"Helvetica-SemiBold", size: 10)
        headerView.addSubview(label)
        
        return headerView
    }
    

    //MARK - Table View - Deletion cells and meals in core data
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            //Read the sections and all refeicao inside
            self.contextMeal = RefeicaoServices.findByWeek(self.daysInPt[indexPath.section])
            
            //Delete Refeicao
            RefeicaoServices.deleteRefeicaoByUuid(self.contextMeal[indexPath.row].uuid)
            
            //Delete Local Notification
            TodoList.sharedInstance.removeItemById(self.contextMeal[indexPath.row].uuid)
            
            //Delete row
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
        }
    }
    
    
    //MARK - Prepare for segue
    // Prepare for Segue to CollectionVC page -- pass the uuid information from cell clicked
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "selected") {
            
            let destinationViewController = segue.destinationViewController as! CollectionVC
            
            if let indexPath = tableView.indexPathForSelectedRow {
                
                self.contextMeal = RefeicaoServices.findByWeek(self.daysInPt[indexPath.section])
                print(self.contextMeal[indexPath.row])
                
            destinationViewController.meal = Meal(id: self.contextMeal[indexPath.row].uuid , week: [self.contextMeal[indexPath.row].diaSemana], time: self.contextMeal[indexPath.row].horario, name: self.contextMeal[indexPath.row].name, foods: self.contextMeal[indexPath.row].getItemsObject())
                
            }
        }
    }

}

