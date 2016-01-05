
import Foundation
import Alamofire
import SwiftyJSON

class Activity{
    var id:Int = 0
    var resource_state:Int = 0
    var external_id:String = ""
    var upload_id:Int = 0
    var athlete:Athlete = Athlete()
    var name:String = ""
    var distance:Float = 0
    var moving_time:Int = 0
    var elapsed_time:Int = 0
    var total_elevation_gain:Float = 0
    var type:String = ""
    var start_date:NSDate = Activity.DateFromString("1900-01-01T00:00:00-00:00")
    var start_date_local:NSDate = Activity.DateFromString("1900-01-01T00:00:00-00:00")
    var timezone:String = ""
    var start_latlngs:[Float] = []
    var end_latlngs:[Float] = []
    var achievement_count:Int = 0
    var kudos_count:Int = 0
    var comment_count:Int = 0
    var athlete_count:Int = 0
    var photo_count:Int = 0
    var total_photo_count:Int = 0
//    var map:Map = ()
    var trainer:Bool = Bool()
    var commute:Bool = Bool()
    var manual:Bool = Bool()
    var isPrivate:Bool = Bool()
    var flagged:Bool = Bool()
    var average_speed:Float = 0
    var max_speed:Float = 0
    var average_watts:Float = 0
    var max_watts:Int = 0
    var weighted_average_watts:Int = 0
    var kilojoules:Float = 0
    var device_watts:Bool = Bool()
    var average_heartrate:Float = 0
    var max_heartrate:Float = 0
    
    class func DateFromString(dateString:String) -> NSDate
    {
        let dateFormatter = NSDateFormatter()
        let enUSPosixLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateFormatter.dateFromString(dateString)!
    }
    

}