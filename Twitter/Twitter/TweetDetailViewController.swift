//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Kaushik on 9/30/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit
import AFNetworking
class TweetDetailViewController: UIViewController {
    @IBOutlet weak var retweetIconImageView: UIImageView!
    @IBOutlet weak var retweetedLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userScreenameLabel: UILabel!
    @IBOutlet weak var verifiedAccountImageView: UIImageView!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var directMessageButton: UIButton!
    @IBOutlet weak var tweetDateTimeLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    @IBOutlet weak var retweetLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var retweetIconImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mediaImageHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var retweetLabelYConstraint: NSLayoutConstraint!
    @IBOutlet weak var retweetIconTopConstraint: NSLayoutConstraint!
    
    var tweet : Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.userProfileImageView.layer.cornerRadius = 0.5 * self.userProfileImageView.frame.width
        
        let rightBarbutton = UIBarButtonItem(image: UIImage(named:"compose"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(replytoTweet))

        self.navigationItem.rightBarButtonItem = rightBarbutton
        // Do any additional setup after loading the view.
        loadViewForTweet()
        
    }
    
    func replytoTweet() -> Void {
        self.performSegue(withIdentifier: "composeReplyTweet", sender: self)
    }
    
    func loadViewForTweet() -> Void {
        if self.tweet != nil {
            let user = self.tweet?.user
            self.userNameLabel.text = user?.name
            self.userScreenameLabel.text = "@" + (user?.screenName)!
            let veriiedAccount = user?.verifiedAccount
            self.verifiedAccountImageView.isHidden = veriiedAccount! ? false : true
            self.tweetTextView.text = self.tweet?.text
            self.mediaImageHeightConstraint.constant = 0
            self.retweetIconImageHeightConstraint.constant = 0
            self.retweetLabelHeightConstraint.constant = 0
            self.retweetLabelYConstraint.constant = 0
            self.retweetIconTopConstraint.constant = 0
            self.tweetDateTimeLabel.text = self.tweet?.createdAtString
            self.retweetCountLabel.text = "\(self.tweet?.retweetedCount ?? 0)"
            self.likesLabel.text = "\(self.tweet?.favoriteCount ?? 0)"
            if let imgURL = tweet?.user?.profileImageUrl {
                self.userProfileImageView.setImageWith(NSURL(string:imgURL)! as URL)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if(segue.identifier == "composeReplyTweet") {
            if let navController = segue.destination as? UINavigationController {
                let vc = navController.topViewController as! TweetComposeViewController
                vc.replyForTweet(tweet: self.tweet)

            }
        }
    }
 

}
