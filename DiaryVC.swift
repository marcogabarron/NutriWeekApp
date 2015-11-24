
import UIKit


class DiaryVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    //MARK: IBOutlets and other variables and constants
    @IBOutlet weak var diaryCollection: UICollectionView!
    @IBOutlet weak var dateNavigation: UINavigationItem!
    @IBOutlet weak var afterButtonItem: UIBarButtonItem!
    @IBOutlet weak var beforeButtonItem: UIBarButtonItem!
    
    ///Days for String for sections and go next page
//    var daysInPt: [String] = ["Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado"]
    
    //Relative to models and CoreData
    var format = FormatDates()
    var allDaily : [Daily] = []
    
    var date = NSDate()
    var indexToRemove = [6]
    var takingPhoto: Bool = false
    var photoControl = 0
    
    //Relative to save images
    let fileManager = NSFileManager.defaultManager()
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        date = NSDate()
        
        self.dateNavigation.title = self.formatterHour(NSDate())
        
        
        self.dateNavigation.title = self.format.formatDateToYearDatString(NSDate())
        self.disableButtonAfter()
        
        if(DailyServices.allDaily().count > 0){
            let date = NSDate()
            self.allDaily = DailyServices.findByDateDaily(date)
            
            fileManager.fileExistsAtPath(paths)
            
            self.diaryCollection.reloadData()
        }
    }
    
    
    //MARK: CollectionView
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = self.diaryCollection.dequeueReusableCellWithReuseIdentifier("SelectedCollectionViewCell", forIndexPath: indexPath) as! SelectedCollectionViewCell
        
        let daily = self.allDaily[indexPath.row]
        cell.image.hidden = daily.hasImage == false
        
        if(daily.hasImage == true){
            cell.image.image = UIImage(named:  daily.nameImage!)

            let imageHeightProportion = cell.image.image!.size.width / cell.image.frame.width
            cell.image.frame.size.height = cell.image.image!.size.height / imageHeightProportion
            
            cell.image.setNeedsDisplay()
        }
        
        if(daily.fled == false){
            cell.checkImage.image = UIImage(named: "logo")
        }
        
        cell.textLabel.text = daily.descriptionStr
        cell.dateLabel.text = self.format.formatDateToString(daily.date!)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
       // self.performSegueWithIdentifier("daily", sender: indexPath)
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allDaily.count
    }

    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
            let daily = self.allDaily[indexPath.row]

            if(daily.hasImage == false){
                return CGSizeMake(355, 100);

            }
            
            return CGSizeMake(355, 300);
    }
    
    
    //MARK: Action
    @IBAction func beforeButton(sender: UIBarButtonItem) {
        
        date = (date.dateByAddingTimeInterval(-60*60*24))
        
        self.enableButtonAfter()
        self.dateNavigation.title = self.format.formatDateToYearDatString(date)
        
        self.allDaily = DailyServices.findByDateDaily(date)
        
        self.diaryCollection.reloadData()
    }
    
    
    func formatterHour(date: NSDate) -> String{
        let timer = NSDateFormatter()
        timer.dateFormat = "dd/MM/yyyy HH:mm"
        return timer.stringFromDate(date)
    }
    
    @IBAction func afterButton(sender: AnyObject) {
        
        date = (date.dateByAddingTimeInterval(60*60*24))
        
        self.dateNavigation.title = self.format.formatDateToYearDatString(date)
        
        self.allDaily = DailyServices.findByDateDaily(date)
        
        if(self.dateNavigation.title == self.format.formatDateToYearDatString(NSDate())){
            self.disableButtonAfter()
        }
        self.diaryCollection.reloadData()
    }
    
    
    //MARK: Functions
    func disableButtonAfter(){
        self.afterButtonItem.enabled = false
        self.afterButtonItem.title = ""
    }
    
    func enableButtonAfter(){
        self.afterButtonItem.enabled = true
        self.afterButtonItem.title = "Depois"
    }
    

    
    //MARK - Prepare for segue
    /** Prepare for Segue to Week page -- pass the information from Weeks() **/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "Register") {
            let destinationViewController = segue.destinationViewController as! AddDailyVC
            destinationViewController.date = self.date
        }
    }
}
