
import Foundation

class DailyServices {
    
    /**create the Entity ItemCardapio that represent the Food**/
    static func createDaily(date: NSDate, fled: Bool, description: String, hasImage: Bool)
    {
        
        let daily: Daily = Daily()
        daily.date = date
        daily.fled = fled
        daily.descriptionStr = description
        daily.hasImage = hasImage
        
        DailyDAO.insert(daily)
    }
    
    /** find all ItemCardapio **/
    static func allDaily() -> [Daily] {
        return DailyDAO.findAll()
    }

}
