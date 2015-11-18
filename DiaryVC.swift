
import UIKit


class DiaryVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    @IBOutlet weak var diaryCollection: UICollectionView!
    
    var diasPT: [String] = ["Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado"]
    var meals = [[Refeicao]]()
    let date = NSDate()
    var date2 = NSDate()
    let dateFormatter = NSDateFormatter()
    var weekDate = [NSDate]()
    var weekDay = [String]()
    var allDaily = [[Daily]]()
//    let day: DailyModel = DailyModel()
    var indexToRemove = [6]
    var takingPhoto: Bool = false
    var photoControl = 0
    
    
    let fileManager = NSFileManager.defaultManager()
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
            }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = self.diaryCollection.dequeueReusableCellWithReuseIdentifier("SelectedCollectionViewCell", forIndexPath: indexPath) as! SelectedCollectionViewCell
        
            cell.image.image = UIImage(named: "grape")

            cell.image.layer.masksToBounds = true
            cell.image.layer.cornerRadius = cell.frame.width/3
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
       // self.performSegueWithIdentifier("daily", sender: indexPath)
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func getDayOfWeek(today:NSDate)->Int {
        
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.Weekday, fromDate: today)
        let weekDay = myComponents.weekday
        return weekDay
    }
    
    func settingWeekDay(var sender: Int, var today: NSDate) -> NSDate{
        
        self.dateFormatter.dateFormat = "dd/MM/yyyy"
        
        if sender != 1{
            
            while (sender != 1) {
                
                today = (today.dateByAddingTimeInterval(-60*60*24))
                sender =  getDayOfWeek(today)
                
            }
        }
        self.date2 = today
        for(var i = 0; i < 7; i++){
            self.weekDay.append(dateFormatter.stringFromDate(today))
            today = (today.dateByAddingTimeInterval(60*60*24))
            //teste = dateFormatter.stringFromDate(date2)
        }
        
        return date2
        
    }
    
    @IBAction func beforeButton(sender: UIBarButtonItem) {
        
        self.weekDay.removeAll()
        date2 = (date2.dateByAddingTimeInterval(-60*60*24*7))
        
        let weekday = getDayOfWeek(date2)
        settingWeekDay(weekday, today: date2)
        self.diaryCollection.reloadData()
        
    }
    
}
