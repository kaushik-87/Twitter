//
//  TweeterUtility.swift
//  Twitter
//
//  Created by Kaushik on 10/1/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit

class TweeterUtility: NSObject {
    
    class func numberToString(from: Int) -> String {
        let number = Double(from)
        let thousand = number / 1000
        let million = number / 1000000
        
        if million >= 1.0 { return "\(round(million*10)/10)M" }
        else if thousand >= 1.0 { return "\(round(thousand*10)/10)K" }
        else { return "\(Int(number))"}
    }
    
    class func dateToString(createdDate: NSDate) -> String {
        
        let formatter           = DateFormatter()
        formatter.dateFormat    = "M/d/yy, h:mm a"
        let dateInStr           = formatter.string(from: createdDate as Date)
        return dateInStr
        
        
    }

}
