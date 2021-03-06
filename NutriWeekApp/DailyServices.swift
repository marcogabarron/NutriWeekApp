
import Foundation

class DailyServices {
    
    
    static func createDaily(date: NSDate)->Daily{
        let daily: Daily = Daily()
        daily.date = date
        daily.hasImage = false
        
        
        DailyDAO.insert(daily)
        return daily

    }
    
    /** Create the Entity ItemCardapio that represent the Food **/
    static func createDaily(date: NSDate, fled: Bool, description: String, hasImage: Bool)     {
        
        let daily: Daily = Daily()
        daily.date = date
        daily.fled = fled
        daily.descriptionStr = description
        daily.hasImage = hasImage
        
        DailyDAO.insert(daily)
        

    }
    
    /** Create the Entity ItemCardapio that represent the Food **/
    static func createDaily(date: NSDate, fled: Bool, description: String, hasImage: Bool, name: String)     {
        
        let daily: Daily = Daily()
        daily.date = date
        daily.fled = fled
        daily.descriptionStr = description
        daily.hasImage = hasImage
        daily.nameImage = name
        
        DailyDAO.insert(daily)
        
        
    }
    
    /** Find all Daily **/
    static func allDaily() -> [Daily] {
        return DailyDAO.findAll()
    }
    
    static func editDaily(daily: Daily){
        
        DailyDAO.edit(daily)
    }
    
    static func findByDate(date: NSDate) -> Bool{
        return DailyDAO.findByDateBool(date)
    }
    
    static func findByDateDaily(date: NSDate) -> [Daily]{
        return DailyDAO.findByDate(date)
    }
    
    
}
