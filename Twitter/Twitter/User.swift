//
//  User.swift
//  Twitter
//
//  Created by Kaushik on 9/27/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit
import SwiftyJSON
var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"


let nameKey             = "name"
let screenNameKey       = "screen_name"
let profileImageUrlKey  = "profile_image_url"
let profileImageUrlHTTPSKey  = "profile_background_image_url_https"
let taglineKey          = "description"
let dictionaryKey       = "description"
let locationKey         = "location"
let followingCountKey   = "following"
let followersCountKey   = "followers_count"
let verifiedAccountKey  = "verified"



class User: NSObject {
    var name: String?
    var screenName: String?
    var profileImageUrl: String?
    var tagline: String?
    var location: String?
    var followingCount: Int?
    var followersCount: Int?
    var verifiedAccount: Bool?
    var userDictionary : NSDictionary?

    init(dictionary: NSDictionary) {
        let json = JSON(dictionary)
        
        name = json[nameKey].stringValue
        screenName = json[screenNameKey].stringValue
        profileImageUrl = json[profileImageUrlHTTPSKey].stringValue
        tagline = json[taglineKey].stringValue
        location = json[locationKey].stringValue
        followersCount = json[followersCountKey].intValue
        followingCount = json[followingCountKey].intValue
        verifiedAccount = json[verifiedAccountKey].boolValue
        self.userDictionary = dictionary
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: userDidLogoutNotification), object: nil)
    }
    
    class var currentUser: User? {
        
        get {
            
            if _currentUser == nil {
                
                if let data = UserDefaults.standard.object(forKey: currentUserKey) {
                    do {
                        let dictionary = try JSONSerialization.jsonObject(with: data as! Data, options: []) as! NSDictionary
                        _currentUser = User(dictionary: dictionary)
                        
                    } catch {
                    }
                }
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                
                do {
                    let data = try JSONSerialization.data(withJSONObject: user?.userDictionary! ?? ["":""], options: [])
                    UserDefaults.standard.set(data, forKey: currentUserKey)
                    
                } catch {
                }

            } else {
                UserDefaults.standard.removeObject(forKey: currentUserKey)
            }
            
            UserDefaults.standard.synchronize()

        }
        
        
    }
}
