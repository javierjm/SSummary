//
//  Athlete.swift
//  SSummary
//
//  Created by Javier Jara on 1/5/16.
//  Copyright © 2016 Roco Soft. All rights reserved.
//

import Foundation

class Athlete
{
    var id:Int = 0
    var resource_state:Int = 0
    var firstname:String = ""
    var lastname:String = ""
    var profile_medium:String = ""
    var profile:String = ""
    var city:String = ""
    var state:String = ""
    var country:String = ""
    var sex:String = ""
    var friend:AnyObject? = nil
    var follower:AnyObject? = nil
    var premium:Bool = Bool()
    var created_at:NSDate = Athlete.DateFromString("1900-01-01T00:00:00-00:00")
    var updated_at:NSDate = Athlete.DateFromString("1900-01-01T00:00:00-00:00")
    var follower_count:Int = 0
    var friend_count:Int = 0
    var mutual_friend_count:Int = 0
    var athlete_type:Int = 0
    var date_preference:String = ""
    var measurement_preference:String = ""
    var email:String = ""
    var ftp:Int = 0
    var weight:Float = 0
    var clubs:[Club] = []
    var bikes:[Bike] = []
    var shoes:[Shoe] = []
    
//    func Populate(dictionary:NSDictionary) {
//        
//        id = dictionary["id"] as! Int
//        resource_state = dictionary["resource_state"] as! Int
//        firstname = dictionary["firstname"] as! String
//        lastname = dictionary["lastname"] as! String
//        profile_medium = dictionary["profile_medium"] as! String
//        profile = dictionary["profile"] as! String
//        city = dictionary["city"] as! String
//        state = dictionary["state"] as! String
//        country = dictionary["country"] as! String
//        sex = dictionary["sex"] as! String
//        friend = dictionary["friend"]
//        follower = dictionary["follower"]
//        premium = dictionary["premium"] as! Bool
//        created_at =  Athlete.DateFromString(dictionary["created_at"] as! String)
//        updated_at =  Athlete.DateFromString(dictionary["updated_at"] as! String)
//        follower_count = dictionary["follower_count"] as! Int
//        friend_count = dictionary["friend_count"] as! Int
//        mutual_friend_count = dictionary["mutual_friend_count"] as! Int
//        athlete_type = dictionary["athlete_type"] as! Int
//        date_preference = dictionary["date_preference"] as! String
//        measurement_preference = dictionary["measurement_preference"] as! String
//        email = dictionary["email"] as! String
//        ftp = dictionary["ftp"] as! Int
//        weight = dictionary["weight"] as! Float
//        clubs = Club.PopulateArray(dictionary["clubs"] as! [NSArray])
//        bikes = Bike.PopulateArray(dictionary["bikes"] as! [NSArray])
//        shoes = Shoe.PopulateArray(dictionary["shoes"] as! [NSArray])
//    }
//    
    class func DateFromString(dateString:String) -> NSDate
    {
        let dateFormatter = NSDateFormatter()
        let enUSPosixLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateFormatter.dateFromString(dateString)!
    }
//
//    class func Populate(data:NSData) -> Athlete {
//        var jsonResults = Athlete()
//        do {
//            jsonResults = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! Athlete
//            // success ...
//        } catch {
//            // failure
//            print("Fetch failed: \((error as NSError).localizedDescription)")
//        }
//        
//        return jsonResults
//    }
//    
//    class func Populate(dictionary:NSDictionary) -> Athlete
//    {
//        let result = Athlete()
//        result.Populate(dictionary)
//        return result
//    }
    
}

