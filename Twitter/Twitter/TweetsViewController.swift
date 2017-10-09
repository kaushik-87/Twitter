//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Kaushik on 9/28/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate , TweetComposeViewControllerDelegate , TweetCellDelegate, UIGestureRecognizerDelegate {
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return (self.tweets?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let tweetCell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TimelineTweetCell
        tweetCell.tweetCellDelegate = self
        tweetCell.tweet = self.tweets?[indexPath.row]
        return tweetCell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (!isMoreDataLoading){
            let scrollViewContentHeight = self.tweetsTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - self.tweetsTableView.bounds.size.height
            if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tweetsTableView.isDragging) {
                isMoreDataLoading = true
                let lastTweet = self.tweets?[(self.tweets?.count)!-1]
                TwitterClient.sharedInstance.homeTimeLineFetchNextTweets(fromTweet: lastTweet!, completion: { (tweets : [Tweet]?, error:Error?) in
                    self.tweets?.removeLast()
                    for tweet in tweets! {
                        self.tweets?.append(tweet)
                    }
                    
                    self.tweetsTableView.reloadData()
                    self.isMoreDataLoading = false
                })
                print("Load more Tweets")
            }
        }

    }
    
    func tweetCell(cell: TimelineTweetCell, didTapOnFavButtonForTweet: Tweet) {
        
        
    }
    func tweetCell(cell: TimelineTweetCell, didTapOnReplyButtonForTweet tweet: Tweet) {

    }

    func tweetCell(cell: TimelineTweetCell, didTapOnUserIconForTweet tweet: Tweet) {
        
        
        let profileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileViewController") as! ProfileViewController
        self.navigationController?.pushViewController(profileViewController, animated: true)
        profileViewController.currentUser = tweet.user
        //                profileViewController.loadProfileDetailsFor(user : User.currentUser)
        
    }
    func tweetCell(cell: TimelineTweetCell, didTapOnRetweetButtonForTweet tweet: Tweet) {
        
        let alert = UIAlertController(title: "", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        // add the actions (buttons)
        let reTweetTitle = (tweet.retweeted)! ? "Undo Retweet" : "Retweet"
        let actionStyle = (reTweetTitle == "Undo Retweet") ? UIAlertActionStyle.destructive : UIAlertActionStyle.default
        alert.addAction(UIAlertAction(title: reTweetTitle, style: actionStyle, handler: { (action: UIAlertAction) in
            print("Retweet")
            if let retweeted = tweet.retweeted {
                if retweeted == true {
//                    tweet.retweeted = false
//                    if let count = tweet.retweetedCount {
//                        tweet.retweetedCount = count-1
//                    }
                    TwitterClient.sharedInstance.unReTweet(tweet: tweet, completion: { (tweet : Tweet?,error: Error?) in
                        if tweet != nil {
                            DispatchQueue.main.async {
                                self.loadTweetTimeLine()
                            }
                        }
                    })
                }else{
//                    tweet.retweeted = true
//                    if let count = tweet.retweetedCount {
//                        tweet.retweetedCount = count+1
//                    }
                    TwitterClient.sharedInstance.reTweet(tweet: tweet, completion: { (tweet : Tweet?,error: Error?) in
                        if tweet != nil {
                            DispatchQueue.main.async {
                                self.loadTweetTimeLine()
                            }
                        }
                    })
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) in
            print("cancel")
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    @IBOutlet weak var tweetsTableView: UITableView!
    let refreshControl = UIRefreshControl()

    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        loadTweetTimeLine()
    }
    
    func loadTweetTimeLine() -> Void {
        
        if User.currentUser != nil {
            TwitterClient.sharedInstance.homeTimelineWithParams(params: nil) { (tweets:[Tweet]?,err: Error?) in
                
                if tweets != nil {
                    DispatchQueue.main.async {
                        self.refreshControl.endRefreshing()
                        self.tweets = tweets
                        self.tweetsTableView.reloadData()
                    }
                }
            }
        }else{
            let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginViewController") as! ViewController
            
            self.present(loginViewController, animated: true, completion: {
                
            })
        }

    }

    var tweets : [Tweet]?
    var isMoreDataLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationItem.titleView?.isUserInteractionEnabled = true
//        let longPressGuestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressedOnNavigationBar))
//        longPressGuestureRecognizer.delegate = self
//        self.navigationItem.titleView?.addGestureRecognizer(longPressGuestureRecognizer)
        
        refreshControl.backgroundColor = UIColor.clear
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        self.tweetsTableView.insertSubview(refreshControl, at: 0)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReplyTweet(notification:)), name: Notification.Name("didSendReplyTweetNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didRemoveFromFavorite(notification:)), name: Notification.Name("didRemoveFromFavoriteNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didAddToFavorite(notification:)), name: Notification.Name("didAddToFavoriteNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didUnReTweet(notification:)), name: Notification.Name("didUnRetweetNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReTweet(notification:)), name: Notification.Name("didRetweetNotification"), object: nil)

        self.tweets = [Tweet]()
        self.tweetsTableView.rowHeight = UITableViewAutomaticDimension
        self.tweetsTableView.estimatedRowHeight = 140
        
//        NotificationCenter.default.addObserver(self, selector: #selector(userDidLogout), name:
//            NSNotification.Name(rawValue: userDidLogoutNotification), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(userDidLogin), name:
//            NSNotification.Name(rawValue: userDidLoginNotification), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(accountsDidSwitchAccount), name:
            NSNotification.Name(rawValue: accountManagerDidSwitchUserNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(noLoggedInUser), name:
            NSNotification.Name(rawValue: accountManagerNoLoggedInUsersNotification), object: nil)
        
        loadTweetTimeLine()
        // Do any additional setup after loading the view.
    }
    
      func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool
    {
        return true
    }
    
    func longPressedOnNavigationBar() -> Void {
        print("LongpressRecognized")
    }
    
    func accountsDidSwitchAccount() -> Void {
//        loadTweetTimeLine()
        TwitterClient.sharedInstance.homeTimelineWithParams(params: nil) { (tweets:[Tweet]?,err: Error?) in
            
            if tweets != nil {
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.tweets = tweets
                    self.tweetsTableView.reloadData()
                }
            }
        }

    }
    
    func userDidLogin() -> Void {
        
        loadTweetTimeLine()
    }
    func noLoggedInUser() -> Void {
        
        self.tweets?.removeAll()
        self.tweetsTableView.reloadData()
        
        let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginViewController") as! ViewController
        
        self.present(loginViewController, animated: true, completion: {
            
        })
    }
    
    func userDidLogout() -> Void {
        
        self.tweets?.removeAll()
        self.tweetsTableView.reloadData()
        
        let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginViewController") as! ViewController
        
        self.present(loginViewController, animated: true, completion: {
            
        })
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
        loadTweetTimeLine()
//        if let tweet =  notification.userInfo?[Notification.Name("Tweet")] as? Tweet {
//            self.tweets?[(self.tweetsTableView.indexPathForSelectedRow?.row)!] = tweet
//            self.tweetsTableView.reloadRows(at: [self.tweetsTableView.indexPathForSelectedRow!], with: UITableViewRowAnimation.automatic)
//           // self.tweetsTableView.deselectRow(at: self.tweetsTableView.indexPathForSelectedRow!, animated: false)
//        }
    }
    func didReTweet(notification : NSNotification) -> Void {
        loadTweetTimeLine()

//        if let tweet =  notification.userInfo?[Notification.Name("Tweet")] as? Tweet {
//            self.tweets?[(self.tweetsTableView.indexPathForSelectedRow?.row)!] = tweet
//            self.tweetsTableView.reloadRows(at: [self.tweetsTableView.indexPathForSelectedRow!], with: UITableViewRowAnimation.automatic)
//            //self.tweetsTableView.deselectRow(at: self.tweetsTableView.indexPathForSelectedRow!, animated: false)
//        }
    }
    func didAddToFavorite(notification : NSNotification) -> Void {
        loadTweetTimeLine()

//        if let tweet =  notification.userInfo?[Notification.Name("Tweet")] as? Tweet {
//            self.tweets?[(self.tweetsTableView.indexPathForSelectedRow?.row)!] = tweet
//            self.tweetsTableView.reloadRows(at: [self.tweetsTableView.indexPathForSelectedRow!], with: UITableViewRowAnimation.automatic)
//            //self.tweetsTableView.deselectRow(at: self.tweetsTableView.indexPathForSelectedRow!, animated: false)
//        }
    }
    func didRemoveFromFavorite(notification : NSNotification) -> Void {
        loadTweetTimeLine()

//        if let tweet =  notification.userInfo?[Notification.Name("Tweet")] as? Tweet {
//            self.tweets?[(self.tweetsTableView.indexPathForSelectedRow?.row)!] = tweet
//            self.tweetsTableView.reloadRows(at: [self.tweetsTableView.indexPathForSelectedRow!], with: UITableViewRowAnimation.automatic)
//            //self.tweetsTableView.deselectRow(at: self.tweetsTableView.indexPathForSelectedRow!, animated: false)
//        }
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
