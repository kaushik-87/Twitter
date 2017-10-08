//
//  TwitterClient.swift
//  Twitter
//
//  Created by Kaushik on 9/26/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit
import BDBOAuth1Manager


let twitterConsumerKey = "VryCdIDG9zyLVxghGMwWtc39b"
//"FGbzbagCvl7yCvSmZeHxR6SpY"
let twitterConsumerSecret = "NXuCSAkXM1wbDIexybY2rGGxBrOSVomSs7owZaTc3zAqCwlP1k"
//"9dib7dqmdHcMkOroNQ2I1xsMOr1hqhHd6V9wpkrWzRNsP4O9CA"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")
let accessTokenKey = ""
let count = 50


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
            print("Request Token \(requestToken?.token)")
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
    
    func fetchTwitterDetails(tweetId: String, completion: @escaping (_ tweet: Tweet?, _ error : Error?)->()) -> Void {
        let params = ["id":tweetId]
        get("1.1/statuses/show.json", parameters: params
            , progress: nil, success: { (task: URLSessionDataTask, response :Any?) in
                print("Timeline \(String(describing: response))")
                let tweet = Tweet(dictionary: response as! NSDictionary)
                completion(tweet, nil)
        }, failure: { (task:URLSessionDataTask?, error:Error) in
            print("error")
            completion(nil,error)
        })
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
    
    
    
    func homeTimeLineFetchNextTweets(fromTweet : Tweet, completion: @escaping (_ tweets: [Tweet]?, _ error : Error?)->()) -> Void {
        let params = ["count":count,"max_id":fromTweet.id!, "access_token":User.currentUser?.accessToken ?? ""] as NSDictionary
        homeTimelineWithParams(params: params, completion: completion)
    }
    
    func postNewTweet(newTweetText : String, completion : @escaping (_ twwet: Tweet?, _ error : Error?)->()) -> Void {
        postTweet(params: ["status":newTweetText], completion: completion)

    }
    
    func  fetchUserTweetsTimeline(user: User?, completion: @escaping (_ tweets: [Tweet]?, _ error : Error?)->()) -> Void  {
        if let screenName = user?.screenName {
            fetchProfileTimeline(params: ["count":count, "screen_name": screenName], completion: completion)
        }else{
            print("User doesnot contain screen name!!!")
        }
    }
    
    func fetchProfileTimeline(params: NSDictionary?, completion: @escaping (_ tweets: [Tweet]?, _ error : Error?)->()) -> Void  {
        get("1.1/statuses/user_timeline.json", parameters: params
            , progress: nil, success: { (task: URLSessionDataTask, response :Any?) in
                print("Timeline \(String(describing: response))")
                let tweets = Tweet.tweetsWithArray(array: response as! [NSDictionary])
                completion(tweets, nil)
        }, failure: { (task:URLSessionDataTask?, error:Error) in
            print("error")
            completion(nil,error)
        })
    }
    
    func fetchMentionsTimeline(completion: @escaping (_ tweets: [Tweet]?, _ error : Error?)->()) -> Void {
        get("1.1/statuses/mentions_timeline.json", parameters: ["count":count]
            , progress: nil, success: { (task: URLSessionDataTask, response :Any?) in
                print("Timeline \(String(describing: response))")
                let tweets = Tweet.tweetsWithArray(array: response as! [NSDictionary])
                completion(tweets, nil)
        }, failure: { (task:URLSessionDataTask?, error:Error) in
            print("error")
            completion(nil,error)
        })
    }
    
    func postReply(tweetText: String, toTweet: Tweet, completion : @escaping (_ twwet: Tweet?, _ error : Error?)->()) -> Void {
        
        postTweet(params: ["status":tweetText,"in_reply_to_status_id":toTweet.id!], completion: completion)
    }
    
    func postTweet(params: NSDictionary?, completion : @escaping (_ twwet: Tweet?, _ error : Error?)->()) -> Void {
        let urlString = "/1.1/statuses/mentions_timeline.json"
        post(urlString, parameters: params, progress: nil, success: { (task :URLSessionDataTask, response :Any?) in
            print("Success Response =\(response)")
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet, nil)
        }) { (task : URLSessionDataTask?, error: Error?) in
            print("Error")
            completion(nil,error)
        }
    }
    
    func retweetAndUnretweet(urlPath: String?, params: NSDictionary?, completion : @escaping (_ tweet: Tweet?, _ error : Error?)->()) -> Void {
        
        post(urlPath!, parameters: params, progress: nil, success: { (task :URLSessionDataTask, response: Any?) in
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet, nil)
        }) { (task: URLSessionDataTask?, error:Error) in
            completion(nil,error)
        }
    }
    
    
    func favoriteUnFavourite(urlPath: String?, params: NSDictionary?, completion : @escaping (_ tweet: Tweet?, _ error : Error?)->()) -> Void {
        post(urlPath!, parameters: params, progress: nil, success: { (task :URLSessionDataTask, response: Any?) in
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet, nil)
        }) { (task: URLSessionDataTask?, error:Error) in
            completion(nil,error)

        }
    }
    
    func reTweet(tweet: Tweet?, completion : @escaping (_ tweet: Tweet?, _ error : Error?)->()) -> Void {
        if let tweetId =  tweet?.id {
            let urlPath = "1.1/statuses/retweet/\(tweetId).json"
            retweetAndUnretweet(urlPath: urlPath, params: nil, completion: completion)
        }
    }
    
    func unReTweet(tweet: Tweet?, completion : @escaping (_ tweet: Tweet?, _ error : Error?)->()) -> Void {
        if let tweetId =  tweet?.id {
            let urlPath = "1.1/statuses/destroy/\(tweetId).json"
            retweetAndUnretweet(urlPath: urlPath, params: nil, completion: completion)
        }
    }
    
    func addToFavourite(tweet: Tweet?, completion : @escaping (_ tweet: Tweet?, _ error : Error?)->()) -> Void {
        if let tweetId =  tweet?.id {
            let urlPath = "1.1/favorites/create.json"
            favoriteUnFavourite(urlPath: urlPath, params: ["id":tweetId], completion: completion)
        }
    }
    
    func removeFromFavourite(tweet: Tweet?, completion : @escaping (_ tweet: Tweet?, _ error : Error?)->()) -> Void {
        if let tweetId =  tweet?.id {
            let urlPath = "1.1/favorites/destroy.json"
            favoriteUnFavourite(urlPath: urlPath, params: ["id":tweetId], completion: completion)

        }
    }
    
    
    
    func openURL(url : NSURL?){
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken:
            BDBOAuth1Credential(queryString: url?.query), success: { (accessToken: BDBOAuth1Credential?) in
                
                print("Got access token")
                //TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                
                let accessTokenInString  = accessToken?.token
                let bdbAccessCredential = accessToken
                TwitterClient.sharedInstance.get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (dataTask : URLSessionDataTask, response : Any?) in
                    
                    print("Response\(String(describing: response))")
                    let user = User(dictionary: response as! NSDictionary) 
                    user.accessToken = accessTokenInString
                    user.bdbAccessCredential = bdbAccessCredential
                    print("user : \(String(describing: user.name))")
                    User.currentUser = user
                    AccountsManager.sharedInstance.addUserToAccounts(user: user)
                    self.loginCompletion?(user,nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: userDidLoginNotification), object: nil)

                    
                }, failure: { (dataTask: URLSessionDataTask?, error: Error) in
                    self.loginCompletion?(nil,error)

                })
                
        }) { (error: Error?) in
            self.loginCompletion?(nil,error)
        }
    }
    
}

