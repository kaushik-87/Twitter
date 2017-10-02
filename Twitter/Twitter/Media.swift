//
//  Media.swift
//  Twitter
//
//  Created by Kaushik on 10/1/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit
import SwiftyJSON

class Media: NSObject {
    
    var type : String?
    var mediaURL : String?
    var mediumSize : CGSize?
    var smallSize : CGSize?
    
    
    init(dictionary: NSDictionary){
        let json = JSON(dictionary)
        type = json["type"].string
        mediaURL = json["media_url_https"].string
        if let sizeArrayDict = json["sizes"].dictionary{
            if let mediumSizeDict = sizeArrayDict["medium"]?.dictionary{
                if let width = mediumSizeDict["w"]?.int, let height = mediumSizeDict["h"]?.int{
                    mediumSize = CGSize(width: width, height: height)
                }
            }
            
            if let smallSizeDict = sizeArrayDict["small"]?.dictionary{
                if let width = smallSizeDict["w"]?.int, let height = smallSizeDict["h"]?.int{
                    smallSize = CGSize(width: width, height: height)
                }
            }
            
        }

        
    }

}
