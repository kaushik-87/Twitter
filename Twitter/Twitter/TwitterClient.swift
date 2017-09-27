//
//  TwitterClient.swift
//  Twitter
//
//  Created by Kaushik on 9/26/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit
import BDBOAuth1Manager


let twitterConsumerKey = "FGbzbagCvl7yCvSmZeHxR6SpY"
let twitterConsumerSecret = "9dib7dqmdHcMkOroNQ2I1xsMOr1hqhHd6V9wpkrWzRNsP4O9CA"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    
    class var sharedInstance : TwitterClient {
        struct Static {
            static let instance = TwitterClient.init(baseURL: twitterBaseURL! as URL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance!
    }
    
    
}
