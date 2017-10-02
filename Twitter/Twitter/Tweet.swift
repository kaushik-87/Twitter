//
//  Tweet.swift
//  Twitter
//
//  Created by Kaushik on 9/27/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit
import SwiftyJSON

let userKey             = "user"
let textKey             = "text"
let createdAtKey        = "created_at"
let favoriteCountKey    = "favorite_count"
let retweetCountKey     = "retweet_count"
let favouritedKey       = "favorited"
let retweetedKey        = "retweeted"
let idStrKey            = "id_str"

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var favoriteCount: Int?
    var retweetedCount: Int?
    var favourited : Bool?
    var retweeted : Bool?
    var id : String?
    var retweetedTweet : Tweet?
    var media : Media?
    
    init(dictionary: NSDictionary) {
        let json                = JSON(dictionary)
        user                    = User(dictionary: json[userKey].dictionary! as NSDictionary)
        text                    = json[textKey].stringValue
        createdAtString         = json[createdAtKey].stringValue
        let formatter           = DateFormatter()
        formatter.dateFormat    = "EEE MMM d HH:mm:ss Z y"
        createdAt               = formatter.date(from: createdAtString!)! as NSDate
        favoriteCount           = json[favoriteCountKey].intValue
        retweetedCount          = json[retweetCountKey].intValue
        favourited              = json[favouritedKey].boolValue
        retweeted               = json[retweetedKey].boolValue
        id                      = json[idStrKey].stringValue
        if json["retweeted_status"].dictionary != nil {
            retweetedTweet          = Tweet(dictionary: json["retweeted_status"].dictionary! as NSDictionary)
        }
        if let extendedEntity = json["extended_entities"].dictionary {
            if let mediaArray = extendedEntity["media"]?.array {
               let mediaDict = mediaArray[0].dictionary as NSDictionary?
                media = Media(dictionary: mediaDict!)
            }
        }
    }
    
    class func tweetsWithArray(array: [NSDictionary]) ->[Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
}
