//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Kaushik on 9/28/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate , TweetComposeViewControllerDelegate {
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return (self.tweets?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let tweetCell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TimelineTweetCell
        
        tweetCell.tweet = self.tweets?[indexPath.row]
        return tweetCell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    @IBOutlet weak var tweetsTableView: UITableView!

    var tweets : [Tweet]?
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didReplyTweet(notification:)), name: Notification.Name("didSendReplyTweetNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didRemoveFromFavorite(notification:)), name: Notification.Name("didRemoveFromFavoriteNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didAddToFavorite(notification:)), name: Notification.Name("didAddToFavoriteNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didUnReTweet(notification:)), name: Notification.Name("didUnRetweetNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReTweet(notification:)), name: Notification.Name("didRetweetNotification"), object: nil)

        self.tweets = [Tweet]()
        self.tweetsTableView.rowHeight = UITableViewAutomaticDimension
        self.tweetsTableView.estimatedRowHeight = 140
        TwitterClient.sharedInstance.homeTimelineWithParams(params: nil) { (tweets:[Tweet]?,err: Error?) in
            self.tweets = tweets
            self.tweetsTableView.reloadData()
            for tweet in self.tweets! {
                print("\(tweet.text)")
            }
        }
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logout(_ sender: Any) {
        
        User.currentUser?.logout()
    }

    func tweetComposeViewController(viewController: TweetComposeViewController, didPostNewTweet tweet: Tweet) {
        insertNewTweetAndReloadView(tweet: tweet)
    }
    
    
    func didUnReTweet(notification : NSNotification) -> Void {
        if let tweet =  notification.userInfo?[Notification.Name("Tweet")] as? Tweet {
            self.tweets?[(self.tweetsTableView.indexPathForSelectedRow?.row)!] = tweet
            self.tweetsTableView.reloadRows(at: [self.tweetsTableView.indexPathForSelectedRow!], with: UITableViewRowAnimation.automatic)
           // self.tweetsTableView.deselectRow(at: self.tweetsTableView.indexPathForSelectedRow!, animated: false)
        }
    }
    func didReTweet(notification : NSNotification) -> Void {
        if let tweet =  notification.userInfo?[Notification.Name("Tweet")] as? Tweet {
            self.tweets?[(self.tweetsTableView.indexPathForSelectedRow?.row)!] = tweet
            self.tweetsTableView.reloadRows(at: [self.tweetsTableView.indexPathForSelectedRow!], with: UITableViewRowAnimation.automatic)
            //self.tweetsTableView.deselectRow(at: self.tweetsTableView.indexPathForSelectedRow!, animated: false)
        }
    }
    func didAddToFavorite(notification : NSNotification) -> Void {
        if let tweet =  notification.userInfo?[Notification.Name("Tweet")] as? Tweet {
            self.tweets?[(self.tweetsTableView.indexPathForSelectedRow?.row)!] = tweet
            self.tweetsTableView.reloadRows(at: [self.tweetsTableView.indexPathForSelectedRow!], with: UITableViewRowAnimation.automatic)
            //self.tweetsTableView.deselectRow(at: self.tweetsTableView.indexPathForSelectedRow!, animated: false)
        }
    }
    func didRemoveFromFavorite(notification : NSNotification) -> Void {
        if let tweet =  notification.userInfo?[Notification.Name("Tweet")] as? Tweet {
            self.tweets?[(self.tweetsTableView.indexPathForSelectedRow?.row)!] = tweet
            self.tweetsTableView.reloadRows(at: [self.tweetsTableView.indexPathForSelectedRow!], with: UITableViewRowAnimation.automatic)
            //self.tweetsTableView.deselectRow(at: self.tweetsTableView.indexPathForSelectedRow!, animated: false)
        }
    }
    
    func didReplyTweet(notification : NSNotification) -> Void {
        insertNewTweetAndReloadView(tweet: notification.userInfo?[Notification.Name("Tweet")] as? Tweet)
    }
    
    func insertNewTweetAndReloadView(tweet: Tweet?) -> Void {
        self.tweets?.insert(tweet!, at: 0)
        self.tweetsTableView.reloadData()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if(segue.identifier == "tweetDetail") {
            
            let vc = segue.destination as! TweetDetailViewController
            if let cell = sender as? TimelineTweetCell{
                if let indesPath = self.tweetsTableView.indexPath(for: cell) {
                    vc.tweet = self.tweets?[indesPath.row]
                }
            }
        }
        else if (segue.identifier == "composeNewTweet") {
            if let navController = segue.destination as? UINavigationController {
                let vc = navController.topViewController as! TweetComposeViewController
                vc.replyForTweet(tweet: nil)
                vc.composeTweetDelegate = self
                
            }
        }
    }
 

}
