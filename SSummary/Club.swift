//
//  Club.swift
//  SSummary
//
//  Created by Javier Jara on 1/5/16.
//  Copyright © 2016 Roco Soft. All rights reserved.
//

import Foundation

class Club {
    
    var id:Int = 0
    var resource_state:Int = 0
    var name:String = ""
    var profile_medium:String = ""
    var profile:String = ""
    
    func Populate(dictionary:NSDictionary) {
        
        id = dictionary["id"] as! Int
        resource_state = dictionary["resource_state"] as! Int
        name = dictionary["name"] as! String
        profile_medium = dictionary["profile_medium"] as! String
        profile = dictionary["profile"] as! String
    }
    
    class func PopulateArray(array:NSArray) -> [Club]
    {
        var result:[Club] = []
        for item in array
        {
            let newItem = Club()
            newItem.Populate(item as! NSDictionary)
            result.append(newItem)
        }
        return result
    }
    
}

