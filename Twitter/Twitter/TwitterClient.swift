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
    
    var loginCompletion : ((_ user : User?, _ error : Error?) -> ())?
    class var sharedInstance : TwitterClient {
        struct Static {
            static let instance = TwitterClient.init(baseURL: twitterBaseURL! as URL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance!
    }

    func loginWithCompletion(completionBlock : @escaping (_ user : User?, _ error : Error?) -> ()) {
        loginCompletion = completionBlock
        
        // fetch request token
        TwitterClient.sharedInstance.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string : "kttwitterdemo://oauth")! as URL, scope: nil, success: { ( requestToken : BDBOAuth1Credential?) in
            if let token = requestToken {
                if let authURL = NSURL(string:"https://api.twitter.com/oauth/authorize?oauth_token=\(token.token!)") {
                    UIApplication.shared.open(authURL as URL, options: ["" : ""], completionHandler: { (Success : Bool) in
                        
                    })
                }
            }
            
        }) { (error : Error?) in
            self.loginCompletion?(nil,error)
            
        }
    }
    
    func homeTimelineWithParams(params:NSDictionary?, completion: @escaping (_ tweets: [Tweet]?, _ error : Error?)->()) -> Void {
        get("1.1/statuses/home_timeline.json", parameters: params
            , progress: nil, success: { (task: URLSessionDataTask, response :Any?) in
            print("Timeline \(String(describing: response))")
            let tweets = Tweet.tweetsWithArray(array: response as! [NSDictionary])
            completion(tweets, nil)
        }, failure: { (task:URLSessionDataTask?, error:Error) in
            print("error")
            completion(nil,error)
        })
    }
    
    func postNewTweet(tweetText: String, params: NSDictionary?, completion : @escaping (_ twwet: Tweet?, _ error : Error?)->()) -> Void {
        guard let urlencodedText = tweetText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else{
            completion(nil, nil)
            return
        }
        
        let urlString = "/1.1/statuses/update.json?status=\(urlencodedText)"
        post(urlString, parameters: nil, progress: nil, success: { (task :URLSessionDataTask, response :Any?) in
            print("Success")
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet, nil)
        }) { (task : URLSessionDataTask?, error: Error?) in
            print("Error")
            completion(nil,error)
        }
    }
    
    func openURL(url : NSURL?){
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken:
            BDBOAuth1Credential(queryString: url?.query), success: { (accessToken: BDBOAuth1Credential?) in
                
                print("Got access token")
                TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                
                TwitterClient.sharedInstance.get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (dataTask : URLSessionDataTask, response : Any?) in
                    
                    print("Response\(String(describing: response))")
                    let user = User(dictionary: response as! NSDictionary)
                    print("user : \(String(describing: user.name))")
                    User.currentUser = user
                    self.loginCompletion?(user,nil)

                    
                }, failure: { (dataTask: URLSessionDataTask?, error: Error) in
                    self.loginCompletion?(nil,error)

                })
                
        }) { (error: Error?) in
            self.loginCompletion?(nil,error)
        }
    }
    
}

