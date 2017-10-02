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
    var tweetToDisplay :Tweet? 
    var tweet : Tweet?{
        didSet {
            if tweet?.retweetedTweet != nil {
                self.tweetToDisplay = tweet?.retweetedTweet!
            }else{
                self.tweetToDisplay = tweet
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mediaImageView.layer.cornerRadius = 5
        self.userProfileImageView.layer.cornerRadius = 0.5 * self.userProfileImageView.frame.width
        
        let rightBarbutton = UIBarButtonItem(image: UIImage(named:"Compose"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(replytoTweet))

        self.navigationItem.rightBarButtonItem = rightBarbutton
        // Do any additional setup after loading the view.
        loadViewForTweet()
        
    }
    
    func replytoTweet() -> Void {
        self.performSegue(withIdentifier: "composeReplyTweet", sender: self)
    }
    
    func loadViewForTweet() -> Void {
        if self.tweet != nil {
            let user = self.tweetToDisplay?.user
            self.userNameLabel.text = user?.name
            self.userScreenameLabel.text = "@" + (user?.screenName)!
            let veriiedAccount = user?.verifiedAccount
            self.verifiedAccountImageView.isHidden = veriiedAccount! ? false : true
            self.tweetTextView.text = self.tweetToDisplay?.text
            if self.tweetToDisplay?.media != nil {
                self.mediaImageHeightConstraint.constant = 220
                    //(self.tweet?.media?.mediumSize?.height)!
                self.mediaImageView.setImageWith(URL(string:(self.tweetToDisplay?.media?.mediaURL)!)!)
                self.retweetIconImageHeightConstraint.constant = 0
                self.retweetLabelHeightConstraint.constant = 0
                self.retweetLabelYConstraint.constant = 0
                self.retweetIconTopConstraint.constant = 0
            }else{
                self.mediaImageHeightConstraint.constant = 0
                self.retweetIconImageHeightConstraint.constant = 0
                self.retweetLabelHeightConstraint.constant = 0
                self.retweetLabelYConstraint.constant = 0
                self.retweetIconTopConstraint.constant = 0
            }

            self.tweetDateTimeLabel.text = TweeterUtility.dateToString(createdDate: (self.tweetToDisplay?.createdAt)!)
            let retweetCountInstring = TweeterUtility.numberToString(from: (self.tweetToDisplay?.retweetedCount)!)

            self.retweetCountLabel.text = "\(retweetCountInstring)"
            let favCountInstring = TweeterUtility.numberToString(from: (self.tweetToDisplay?.favoriteCount)!)

            self.likesLabel.text = "\(favCountInstring)"
            if let imgURL = tweetToDisplay?.user?.profileImageUrl {
                self.userProfileImageView.setImageWith(NSURL(string:imgURL)! as URL)
            }
            
            let imageName = (tweetToDisplay?.favourited)! ? "Favorite" : "Favorite_black"
            self.favouriteButton.setImage(UIImage(named:imageName), for: UIControlState.normal)
            
            let retweetImageName = (self.tweetToDisplay?.retweeted)! ? "Retweet_green" : "Retweet_black"
            self.retweetButton.setImage(UIImage(named:retweetImageName), for: UIControlState.normal)
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
                vc.replyForTweet(tweet: self.tweetToDisplay)

            }
        }
    }
    @IBAction func favAction(_ sender: Any) {
        if let favourited = self.tweetToDisplay?.favourited {
            
            if favourited == true {
                self.tweetToDisplay?.favourited =  false
                if let count = self.tweetToDisplay?.favoriteCount {
                    self.tweetToDisplay?.favoriteCount = count-1
                }
                TwitterClient.sharedInstance.removeFromFavourite(tweet: self.tweetToDisplay, completion: { (tweet:Tweet?, error:Error?) in
                    if tweet != nil {
                        
                        TwitterClient.sharedInstance.unReTweet(tweet: self.tweetToDisplay, completion: { (tweet : Tweet?,error: Error?) in
                            if tweet != nil {
                                DispatchQueue.main.async {
                                    let userInfo = [Notification.Name("Tweet"): tweet!]
                                    let didRemoveFromFavoriteNotification = Notification(name: Notification.Name("didRemoveFromFavoriteNotification"), object: self, userInfo: userInfo)
                                    NotificationCenter.default.post(didRemoveFromFavoriteNotification)
                                }
                            }
                        })

                    }
                })
            }else{
                self.tweetToDisplay?.favourited = true
                if let count = self.tweetToDisplay?.favoriteCount {
                    self.tweetToDisplay?.favoriteCount = count+1
                }
                TwitterClient.sharedInstance.addToFavourite(tweet: self.tweetToDisplay, completion: { (tweet:Tweet?, error:Error?) in
                    if tweet != nil {
                        TwitterClient.sharedInstance.unReTweet(tweet: self.tweetToDisplay, completion: { (tweet : Tweet?,error: Error?) in
                            if tweet != nil {
                                DispatchQueue.main.async {
                                    let userInfo = [Notification.Name("Tweet"): tweet!]
                                    let didAddToFavoriteNotification = Notification(name: Notification.Name("didAddToFavoriteNotification"), object: self, userInfo: userInfo)
                                    NotificationCenter.default.post(didAddToFavoriteNotification)
                                }
                            }
                        })

                    }
                })
            }
            
            updateFav()

        }
    }
    
    @IBAction func reTweetAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        // add the actions (buttons)
        
        
        let reTweetTitle = (self.tweetToDisplay?.retweeted)! ? "Undo Retweet" : "Retweet"
        let actionStyle = (reTweetTitle == "Undo Retweet") ? UIAlertActionStyle.destructive : UIAlertActionStyle.default
        alert.addAction(UIAlertAction(title: reTweetTitle, style: actionStyle, handler: { (action: UIAlertAction) in
            print("Retweet")
            
            if let retweeted = self.tweetToDisplay?.retweeted {
                if retweeted == true {
                    self.tweetToDisplay?.retweeted = false
                    if let count = self.tweetToDisplay?.retweetedCount {
                        self.tweetToDisplay?.retweetedCount = count-1
                    }
                    TwitterClient.sharedInstance.unReTweet(tweet: self.tweetToDisplay, completion: { (tweet : Tweet?,error: Error?) in
                        if tweet != nil {
                            
                            TwitterClient.sharedInstance.fetchTwitterDetails(tweetId: (tweet?.id)!, completion: { (tweet : Tweet?, error:Error?) in
                                if tweet != nil {
                                    DispatchQueue.main.async {
                                        let userInfo = [Notification.Name("Tweet"): tweet!]
                                        let didUnRetweetNotification = Notification(name: Notification.Name("didUnRetweetNotification"), object: self, userInfo: userInfo)
                                        NotificationCenter.default.post(didUnRetweetNotification)
                                    }
                                }
                            })

                        }
                    })
                }else{
                    self.tweetToDisplay?.retweeted = true
                    if let count = self.tweetToDisplay?.retweetedCount {
                        self.tweetToDisplay?.retweetedCount = count+1
                    }
                    TwitterClient.sharedInstance.reTweet(tweet: self.tweet, completion: { (tweet : Tweet?,error: Error?) in
                        if tweet != nil {
                            
                            TwitterClient.sharedInstance.fetchTwitterDetails(tweetId: (tweet?.id)!, completion: { (tweet : Tweet?, error:Error?) in
                                if tweet != nil {
                                    DispatchQueue.main.async {
                                        let userInfo = [Notification.Name("Tweet"): tweet!]
                                        let didRetweetNotification = Notification(name: Notification.Name("didRetweetNotification"), object: self, userInfo: userInfo)
                                        NotificationCenter.default.post(didRetweetNotification)
                                    }
                                }
                            })

                        }
                    })
                }
                self.updateRetweet()
            }
        }))
            
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) in
            print("cancel")
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    func updateFav() -> Void {
        
        UIView.animate(withDuration: 0.6, animations: {
            self.favouriteButton.transform = CGAffineTransform.identity.scaledBy(x: 0.6, y: 0.6)
        }, completion: { (finish) in
            UIView.animate(withDuration: 0.6, animations: {
                self.favouriteButton.transform = CGAffineTransform.identity
                let imageName = (self.tweetToDisplay?.favourited)! ? "Favorite" : "Favorite_black"
                self.favouriteButton.setImage(UIImage(named:imageName), for: UIControlState.normal)
                
            })
        })


        let favCountInstring = TweeterUtility.numberToString(from: (self.tweetToDisplay?.favoriteCount)!)

        self.likesLabel.text = "\(favCountInstring)"
    }
    
    func updateRetweet() {
        
        UIView.animate(withDuration: 0.6, animations: {
            self.retweetButton.transform = CGAffineTransform.identity.scaledBy(x: 0.6, y: 0.6)
        }, completion: { (finish) in
            UIView.animate(withDuration: 0.6, animations: {
                self.retweetButton.transform = CGAffineTransform.identity
                let imageName = (self.tweetToDisplay?.retweeted)! ? "Retweet_green" : "Retweet_black"
                self.retweetButton.setImage(UIImage(named:imageName), for: UIControlState.normal)

            })
        })
        
        let retweetCountInstring = TweeterUtility.numberToString(from: (self.tweetToDisplay?.retweetedCount)!)
        self.retweetCountLabel.text = "\(retweetCountInstring)"

    }

}
