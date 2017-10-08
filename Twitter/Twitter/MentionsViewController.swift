//
//  MentionsViewController.swift
//  Twitter
//
//  Created by Kaushik on 10/7/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        if (self.mentionedTweets?.count)!>0 {
            cell.tweet = self.mentionedTweets?[indexPath.row]
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.mentionedTweets?.count)!
    }


    @IBOutlet weak var mentionsTableView: UITableView!
    var mentionedTweets : [Tweet]?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mentionedTweets = [Tweet]()

        let nib = UINib(nibName: "TweetCell", bundle: nil)
        self.mentionsTableView.register(nib, forCellReuseIdentifier: "tweetCell")
        self.mentionsTableView.estimatedRowHeight = self.mentionsTableView.rowHeight
        self.mentionsTableView.rowHeight = UITableViewAutomaticDimension
        loadMentionedTweets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func loadMentionedTweets() -> Void {
        TwitterClient.sharedInstance.fetchMentionsTimeline() { (tweets: [Tweet]?, error: Error?) in
            if (tweets?.count)!>0 {
                DispatchQueue.main.async {
                    self.mentionedTweets = tweets
                    self.mentionsTableView.reloadData()
                }
            }
            else{
                print("No mentions yet")
                self.mentionsTableView.isHidden = true
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
