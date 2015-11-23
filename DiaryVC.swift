
import UIKit


class DiaryVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    @IBOutlet weak var diaryCollection: UICollectionView!
    @IBOutlet weak var dateNavigation: UINavigationItem!
    @IBOutlet weak var afterButtonItem: UIBarButtonItem!
    @IBOutlet weak var beforeButtonItem: UIBarButtonItem!
    
    var diasPT: [String] = ["Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado"]
    var date = NSDate()
    var allDaily : [Daily] = []
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
        
        
        self.dateNavigation.title = self.formatterDate(NSDate())
        
        self.disableButtonAfter()
        if(DailyServices.allDaily().count > 0){
            self.allDaily = DailyServices.findByDateDaily(NSDate())
            
            fileManager.fileExistsAtPath(paths)

            self.diaryCollection.reloadData()

        }

    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = self.diaryCollection.dequeueReusableCellWithReuseIdentifier("SelectedCollectionViewCell", forIndexPath: indexPath) as! SelectedCollectionViewCell
        
        let daily = self.allDaily[indexPath.row]
        
        if(daily.hasImage == true){
            
            cell.image.image = UIImage(named: daily.nameImage!)

        }
        
        if(daily.fled == false){
            cell.checkImage.image = UIImage(named: "logo")
        }
        
        cell.textLabel.text = daily.descriptionStr
        cell.dateLabel.text = self.formatterHour(daily.date!)
        
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
    
    func formatterDate(date: NSDate) -> String{
        let timer = NSDateFormatter()
        timer.dateFormat = "dd/MM/yyyy"
        
        let strdate = timer.stringFromDate(date)
        
        return strdate
    }
    
    
    func formatterHour(date: NSDate) -> String{
        let timer = NSDateFormatter()
        timer.dateFormat = "HH:mm"
        
        let strdate = timer.stringFromDate(date)
        
        return strdate
    }
    
    func disableButtonAfter(){
        self.afterButtonItem.enabled = false
        self.afterButtonItem.title = ""
    }
    
    func enableButtonAfter(){
        self.afterButtonItem.enabled = true
        self.afterButtonItem.title = "Depois"
    }
    
    @IBAction func beforeButton(sender: UIBarButtonItem) {
        
        date = (date.dateByAddingTimeInterval(-60*60*24))

        self.enableButtonAfter()
        self.dateNavigation.title = self.formatterDate(date)

        self.allDaily = DailyServices.findByDateDaily(date)

        self.diaryCollection.reloadData()
        
    }
    
    @IBAction func afterButton(sender: AnyObject) {

        date = (date.dateByAddingTimeInterval(60*60*24))
        
        self.dateNavigation.title = self.formatterDate(date)

        self.allDaily = DailyServices.findByDateDaily(date)

        if(self.dateNavigation.title == self.formatterDate(NSDate())){
            self.disableButtonAfter()
        }
        self.diaryCollection.reloadData()
    }
}
