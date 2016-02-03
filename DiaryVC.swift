
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
    var format = NSDateFormatter()
    var allDaily : [Daily] = []
    
    var date = NSDate()
    var indexToRemove = [6]
    var takingPhoto: Bool = false
    var photoControl = 0
    
    //Relative to save images
    let fileManager = NSFileManager.defaultManager()
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    
    //tracker and builder - Google Analytics
    let tracker = GAI.sharedInstance().trackerWithTrackingId("UA-70701653-1")
    let builder = GAIDictionaryBuilder.createScreenView()
    
    let pm = PhotoManager()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.beforeButtonItem.tintColor = UIColor(red: 54/255, green: 173/255, blue: 92/255, alpha: 0.8)
        self.afterButtonItem.tintColor = UIColor(red: 54/255, green: 173/255, blue: 92/255, alpha: 0.8)
    }
    
    override func viewWillAppear(animated: Bool) {
        //Google Analytics - monitoring screens
        tracker.set(kGAIScreenName, value: "See Daily")
        //Google Analytics - monitoring begin
        builder.set(kGAISessionControl, forKey: "start")
        tracker.send(builder.build() as [NSObject : AnyObject])
        
        self.navigationItem.title = NSLocalizedString("Diário", comment: "")
        
        
        super.viewWillAppear(animated)
        date = NSDate()
        
        self.dateNavigation.title = self.format.formatDateToYearDateString(date)
        self.disableButtonAfter()
        self.beforeButtonItem.title = self.format.formatDateToYearDateString(date.dateByAddingTimeInterval(-60*60*24))
        
        if(DailyServices.allDaily().count > 0){
            let date = NSDate()
            self.allDaily = DailyServices.findByDateDaily(date)
            
            fileManager.fileExistsAtPath(paths)
            
            self.diaryCollection.reloadData()
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
        //Google Analytics - monitoring end
        builder.set(kGAISessionControl, forKey: "end")
    }
    
    
    //MARK: CollectionView
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = self.diaryCollection.dequeueReusableCellWithReuseIdentifier("SelectedCollectionViewCell", forIndexPath: indexPath) as! SelectedCollectionViewCell
        
        let daily = self.allDaily[indexPath.row]
        cell.image.hidden = daily.hasImage == false
        
        if(daily.hasImage == true){
            
            pm.getPhoto(daily.nameImage!) {
                image in
                cell.image.image = image
            }
        }
        
        if(daily.fled == true){
            cell.checkImage.image = UIImage(named: "logo")
            cell.checkImage.hidden = false
        }else{
            cell.checkImage.hidden = true
            
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
                return CGSizeMake(self.view.frame.width - 15, 100);
                
            }
            
            return CGSizeMake(self.view.frame.width - 15, 300);
    }
    
    
    //MARK: Action
    @IBAction func beforeButton(sender: UIBarButtonItem) {
        //Google Analytics - monitoring events - dicover created food
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("Button Before", action: "The user clicks here to see your register of meals", label: nil, value: nil).build() as [NSObject : AnyObject])

        
        date = date.dateByAddingTimeInterval(-60*60*24)
        
        self.enableButtonAfter()
        self.dateNavigation.title = self.format.formatDateToYearDateString(date)
        self.beforeButtonItem.title = self.format.formatDateToYearDateString(date.dateByAddingTimeInterval(-60*60*24))
        self.afterButtonItem.title = self.format.formatDateToYearDateString(date.dateByAddingTimeInterval(60*60*24))
        
        self.allDaily = DailyServices.findByDateDaily(date)
        
        self.diaryCollection.reloadData()
    }
    
    @IBAction func afterButton(sender: AnyObject) {
        //Google Analytics - monitoring events - dicover created food
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("Button After", action: "The user clicks here to see your register of meals", label: nil, value: nil).build() as [NSObject : AnyObject])
        
        date = date.dateByAddingTimeInterval(60*60*24)
        
        self.dateNavigation.title = self.format.formatDateToYearDateString(date)
        self.beforeButtonItem.title = self.format.formatDateToYearDateString(date.dateByAddingTimeInterval(-60*60*24))
        self.afterButtonItem.title = self.format.formatDateToYearDateString(date.dateByAddingTimeInterval(60*60*24))
        
        self.allDaily = DailyServices.findByDateDaily(date)
        
        if(self.dateNavigation.title == self.format.formatDateToYearDateString(NSDate())){
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
