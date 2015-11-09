//


import UIKit

class DiaryVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    @IBOutlet weak var diaryCollection: UICollectionView!
    
    var diasPT: [String] = ["Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado"]
    var meals = [[Refeicao]]()
    let date = NSDate()
    var date2 = NSDate()
    let dateFormatter = NSDateFormatter()
    var teste = String()
    var teste2 = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for var i = 0; i < self.diasPT.count; i++ {
            
            self.meals.append(RefeicaoServices.findByWeek(self.diasPT[i]))
            
        }
        
        self.date2 = self.date
        
        self.dateFormatter.dateFormat = "dd-MM-yyyy"
        for(var i = 0; i < 7; i++){
        self.teste2.append(dateFormatter.stringFromDate(date2))
        self.date2 = (date2.dateByAddingTimeInterval(60*60*24))
        //teste = dateFormatter.stringFromDate(date2)
        
        
            
        }
    print(self.teste2)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
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
            cell.image.image = UIImage(named: "water")
            cell.image.layer.masksToBounds = true
            cell.image.layer.cornerRadius = cell.frame.width/3
            
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

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
                headerViewLabel.labelMonthDay.text = teste2[indexPath.section]
                return headerViewLabel
            default:
                //4
                assert(false, "Unexpected element kind")
            }
    }

}