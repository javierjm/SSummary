//
//  Shoe.swift
//  SSummary
//
//  Created by Javier Jara on 1/5/16.
//  Copyright © 2016 Roco Soft. All rights reserved.
//

import Foundation

class Shoe
{
    var id:String = ""
    var primary:Bool = Bool()
    var name:String = ""
    var distance:Float = 0
    var resource_state:Int = 0
    
    func Populate(dictionary:NSDictionary) {
        
        id = dictionary["id"] as! String
        primary = dictionary["primary"] as! Bool
        name = dictionary["name"] as! String
        distance = dictionary["distance"] as! Float
        resource_state = dictionary["resource_state"] as! Int
    }
    class func PopulateArray(array:NSArray) -> [Shoe]
    {
        var result:[Shoe] = []
        for item in array
        {
            let newItem = Shoe()
            newItem.Populate(item as! NSDictionary)
            result.append(newItem)
        }
        return result
    }
    
}