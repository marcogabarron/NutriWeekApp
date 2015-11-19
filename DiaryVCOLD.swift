//


import UIKit


class DiaryVCOLD: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    
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
    var allDaily = [[Daily]]()
//    let day: DailyModel = DailyModel()
    var indexToRemove = [6]
    var takingPhoto: Bool = false
    var photoControl = 0

    
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
        
        self.afterButton.title = NSLocalizedString("", comment: "")
        self.afterButton.enabled = false
        
        self.beforeButton.title = NSLocalizedString("", comment: "")
        self.beforeButton.enabled = false
        
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        print(takingPhoto)
        
        let weekDayToday = getDayOfWeek(date)
        
        //Determines the dialy needs to be removed according with the day of week. When a day of week has passed, it doesnt suffer changes with meal changes
        switch weekDayToday {
            
            case 1: indexToRemove = [0, 1, 2, 3, 4, 5, 6]
            case 2: indexToRemove = [1, 2, 3, 4, 5, 6]
            case 3: indexToRemove = [2, 3, 4, 5, 6]
            case 4: indexToRemove = [3, 4, 5, 6]
            case 5: indexToRemove = [4, 5, 6]
            case 6: indexToRemove = [5, 6]
            case 7: indexToRemove = [6]
            default: print("This day doesnt exist")
            
        }
        
//        if takingPhoto && day.indexPath.row < indexToRemove.first!{
//            photoControl = 1
//            
//            indexToRemove.insert(day.indexPath.row, atIndex: 0)
//            print (indexToRemove)
//        
//            takingPhoto = false
//        }
//        
        if self.meals == [] {
        
            self.meals.removeAll()
            self.allDaily.removeAll()
//            print(day.indexPath)

            for var i = 0; i < self.diasPT.count; i++ {
            
                var day: [Daily] = []

                self.meals.append(RefeicaoServices.findByWeek(self.diasPT[i]))
                    for m in meals[i] {
                    
                        self.dateFormatter.dateFormat = "yyyy-MM-dd"
                        let dateDay = dateFormatter.stringFromDate(weekDate[i])
                
                        let dateString = dateDay + " " + m.horario + ":00"
                        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        dateFormatter.timeZone = NSTimeZone.localTimeZone()
                        let finalDate = dateFormatter.dateFromString(dateString)
                    
                        if(meals[i] != [] && DailyServices.findByDate(finalDate!) == false){
                            let d = DailyServices.createDaily(finalDate!)
                            day.append(d)
                        }else{
//                            day.append(DailyServices.findByDateDaily(finalDate!))
                        }
                    
//                     DailyServices.createDaily(weekDate[i])
                    }
                allDaily.append(day)
            }
        }
        
        else {
            
            for var i = 0; i < indexToRemove.count; i++ {
                
                if i >= indexToRemove.first {
                    self.meals.removeLast()
                    self.allDaily.removeLast()
                }
                else {
                    self.meals.removeAtIndex(i)
                    self.allDaily.removeAtIndex(i)
                }
            }
            
            for var j = indexToRemove.first!; j < (indexToRemove.count + indexToRemove.first!); j++ {
                let i = indexToRemove[j]
            
                var day: [Daily] = []
                
                self.meals.append(RefeicaoServices.findByWeek(self.diasPT[i]))
                for m in meals[i] {
                    
                    self.dateFormatter.dateFormat = "yyyy-MM-dd"
                    let dateDay = dateFormatter.stringFromDate(weekDate[i])
                    
                    let dateString = dateDay + " " + m.horario + ":00"
                    self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    dateFormatter.timeZone = NSTimeZone.localTimeZone()
                    let finalDate = dateFormatter.dateFromString(dateString)
                    
                    if(meals[i] != [] && DailyServices.findByDate(finalDate!) == false){
                        let d = DailyServices.createDaily(finalDate!)
                        day.append(d)
                    }else{
//                        day.append(DailyServices.findByDateDaily(finalDate!))
                    }
                    
                    //                     DailyServices.createDaily(weekDate[i])
                }
                allDaily.append(day)
            }
            
            if photoControl == 1 {
                photoControl = 0
            }
        }

//        if(day.indexPath != NSIndexPath( index: 99999)){
//            self.allDaily[day.indexPath.section][day.indexPath.row] = day.day!
//        }
        self.diaryCollection.reloadData()
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = self.diaryCollection.dequeueReusableCellWithReuseIdentifier("SelectedCollectionViewCell", forIndexPath: indexPath) as! SelectedCollectionViewCell

        if(meals[indexPath.section].count == 0){
            cell.textLabel.text = ""
            
            cell.image.image = UIImage(named: "add")
            cell.image.layer.masksToBounds = true
            cell.image.layer.cornerRadius = cell.frame.width/3
        }else{

        if(Int(indexPath.row) == self.allDaily[indexPath.section].count ){
            cell.textLabel.text = ""
            
            cell.image.image = UIImage(named: "add")
            cell.image.layer.masksToBounds = true
            cell.image.layer.cornerRadius = cell.frame.width/3
            
            
        }else{
            
            cell.textLabel.text = self.meals[indexPath.section][indexPath.row].name
            cell.textLabel.autoresizesSubviews = true
            if((self.allDaily[indexPath.section][indexPath.row].hasImage) == true){
                cell.image.image = UIImage(named: self.allDaily[indexPath.section][indexPath.row].nameImage!)
            }else{
                cell.image.image = UIImage(named: "logo")
            }
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
                    
               // cell.image.image = UIImage(named: self.allDaily[indexPath.section].nameImage!)

                }
                
            }
        }
        

        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
       
        self.performSegueWithIdentifier("daily", sender: indexPath)
      
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(meals[section].count == 0){
            return meals[section].count+1
        }
        return allDaily[section].count+1
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

                //headerViewLabel.headerViewLabel.text = diasPT[indexPath.section]
                //headerViewLabel.labelMonthDay.text = teste[indexPath.section]

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
    
    //MARK - Prepare for segue
    /** Prepare for Segue to Week page -- pass the information from Weeks() **/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if (segue.identifier == "daily") {
//            let destinationViewController = segue.destinationViewController as! TestController
//            let indexPath = sender as! NSIndexPath
//            day.day = self.allDaily[indexPath.section][indexPath.row]
//            day.indexPath = indexPath
//            destinationViewController.daily = day
//            takingPhoto = true
//
//        }
    }
    
    
    }

    