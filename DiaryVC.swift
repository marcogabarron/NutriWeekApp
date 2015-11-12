//


import UIKit


class DiaryVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    @IBOutlet weak var diaryCollection: UICollectionView!
    @IBOutlet weak var afterButton: UIBarButtonItem!
    @IBOutlet weak var beforeButton: UIBarButtonItem!
    
    var diasPT: [String] = ["Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado"]
    var meals = [[Refeicao]]()
    let date = NSDate()
    var date2 = NSDate()
    let dateFormatter = NSDateFormatter()
    var weekDate = [NSDate]()
    var weekDay = [String]()
    var allDaily = [Daily]()
    
    let fileManager = NSFileManager.defaultManager()
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.date2 = self.date
        
        let weekday = getDayOfWeek(date)
        date2 = settingWeekDay(weekday, today: date)
        
        self.dateFormatter.dateFormat = "dd/MM/yyyy"
        for(var i = 0; i < 7; i++){
            self.weekDay.append(dateFormatter.stringFromDate(date2))
            self.weekDate.append(date2)
            self.date2 = (date2.dateByAddingTimeInterval(60*60*24))
            //teste = dateFormatter.stringFromDate(date2)
        }
        
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var hasNotDaily: Bool = false

        if(DailyServices.findByDate(date2) == false){
            hasNotDaily = true
        }
        
        self.meals.removeAll()
        
        for var i = 0; i < self.diasPT.count; i++ {
            
            self.meals.append(RefeicaoServices.findByWeek(self.diasPT[i]))
            if(hasNotDaily){
                for m in meals[i] {
                    
//                    print(weekDate[i])
//                    print(m.horario)
                    
                    self.dateFormatter.dateFormat = "yyyy-MM-dd"
                    let dateDay = dateFormatter.stringFromDate(weekDate[i])
                
                    let dateString = dateDay + " " + m.horario + ":00"
                    print(dateString)
                    
                    self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    dateFormatter.timeZone = NSTimeZone.localTimeZone()
                    let finalDate = dateFormatter.dateFromString(dateString)
                    
                    
//                    DailyServices.createDaily(weekDate[i])
                }
            }
            
        }
        self.allDaily = DailyServices.allDaily()

        self.diaryCollection.reloadData()
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = self.diaryCollection.dequeueReusableCellWithReuseIdentifier("SelectedCollectionViewCell", forIndexPath: indexPath) as! SelectedCollectionViewCell

        
        if(Int(indexPath.row) == self.meals[indexPath.section].count){
            cell.textLabel.text = ""
            
            cell.image.image = UIImage(named: "add")
            cell.image.layer.masksToBounds = true
            cell.image.layer.cornerRadius = cell.frame.width/3
            
            
        }else{
            
            cell.textLabel.text = self.meals[indexPath.section][indexPath.row].name
            cell.textLabel.autoresizesSubviews = true
            //cell.image.image = UIImage(named: "\(meals[indexPath.row].image)")
            cell.image.image = UIImage(named: "logo")
            cell.image.layer.masksToBounds = true
            cell.image.layer.cornerRadius = cell.frame.width/5
            
            
            if(allDaily.count != 0){
//                let getImagePath = paths.URLByAppendingPathComponent("image\(indexPath.row).png")
//                
//                if (fileManager.fileExistsAtPath(getImagePath)){
//                    
//                    let selectedImage: UIImage = UIImage(contentsOfFile: getImagePath)!
//                    let data: NSData = UIImagePNGRepresentation(selectedImage)!
//                    cell.imageCell.image = selectedImage
//                    
//                }else{
//                    print("FILE NOT AVAILABLE");
//                }
                
                if(allDaily.count > indexPath.section){
                    
                    cell.image.image = UIImage(named: self.allDaily[indexPath.section].nameImage!)

                }
                
            }
            
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
       
        self.performSegueWithIdentifier("daily", sender: indexPath)
      
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meals[section].count+1
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.diasPT.count
    }
    
    func collectionView(collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
            //1
            switch kind {
                //2
            case UICollectionElementKindSectionHeader:
                //3
                let headerViewLabel =
                collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                    withReuseIdentifier: "headerView",
                    forIndexPath: indexPath)
                    as! CollectionDiaryClass
                headerViewLabel.headerViewLabel.text = diasPT[indexPath.section]
                headerViewLabel.labelMonthDay.text = weekDay[indexPath.section]
                return headerViewLabel
            default:
                //4
                assert(false, "Unexpected element kind")
            }
    }
    
    func getDayOfWeek(today:NSDate)->Int {
        
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.Weekday, fromDate: today)
        let weekDay = myComponents.weekday
        print(weekDay)
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

    