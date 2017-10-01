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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logout(_ sender: Any) {
        
        User.currentUser?.logout()
    }

    func tweetComposeViewController(viewController: TweetComposeViewController, didPostNewTweet tweet: Tweet) {
        self.tweets?.insert(tweet, at: 0)
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
