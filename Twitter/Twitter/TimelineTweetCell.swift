//
//  TimelineTweetCell.swift
//  Twitter
//
//  Created by Kaushik on 9/29/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit
import AFNetworking
import NSDateMinimalTimeAgo


@objc protocol TweetCellDelegate {
    @objc optional func tweetCell(cell: TimelineTweetCell, didTapOnRetweetButtonForTweet: Tweet)
    @objc optional func tweetCell(cell: TimelineTweetCell, didTapOnFavButtonForTweet: Tweet)
    @objc optional func tweetCell(cell: TimelineTweetCell, didTapOnReplyButtonForTweet: Tweet)
}


class TimelineTweetCell: UITableViewCell {

    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var tweetTimeLabel: UILabel!
    @IBOutlet weak var userTweetHandlerLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userIconImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var retweetedLabel: UILabel!
    
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var retweetLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var retweetImgConstraint: NSLayoutConstraint!
    @IBOutlet weak var mediaImageHeightConstraint: NSLayoutConstraint!
    
    weak var tweetCellDelegate : TweetCellDelegate?
    var tweet: Tweet? {
        didSet {
            
            var tweetToDisplay = tweet
            if tweet?.retweetedTweet != nil {
                tweetToDisplay = tweet?.retweetedTweet
                self.retweetLabelHeightConstraint.constant = 15
                self.retweetImgConstraint.constant = 15
                if let retweetedBy = tweet?.user?.name {
                    self.retweetedLabel.text = "\(retweetedBy) retweeted"
                    self.retweetImageView.isHidden = false
                    
                }
            }else {
                self.retweetLabelHeightConstraint.constant = 0
                self.retweetImgConstraint.constant = 0
                self.retweetedLabel.text = ""
                self.retweetImageView.isHidden = true
            }


            
            
            self.userNameLabel.text = tweetToDisplay?.user?.name
            if let imgURL = tweetToDisplay?.user?.profileImageUrl {
                self.userIconImageView.setImageWith(NSURL(string:imgURL)! as URL)
            }
            self.tweetTextView.text = tweetToDisplay?.text
            self.userTweetHandlerLabel.text = "@"+(tweetToDisplay?.user?.screenName)!
            
            let date = tweetToDisplay?.createdAt
            let dateInStr = date?.timeAgo()
            self.tweetTimeLabel.text = dateInStr
            
            let imageName = (tweetToDisplay?.favourited)! ? "Favorite" : "Favorite_black"
            self.favouriteButton.setImage(UIImage(named:imageName), for: UIControlState.normal)
            
            let retweetImageName = (tweetToDisplay?.retweeted)! ? "Retweet_green" : "Retweet_black"
            self.retweetButton.setImage(UIImage(named:retweetImageName), for: UIControlState.normal)
            if (tweetToDisplay?.retweetedCount)!>0 {
                let numberInString = TweeterUtility.numberToString(from: (tweetToDisplay?.retweetedCount)!)

                self.retweetButton.setTitle(" \(numberInString)", for: .normal)
 
            }else {
                self.retweetButton.setTitle("", for: .normal)
 
            }
            if (tweetToDisplay?.favoriteCount)!>0 {
                let numberInString = TweeterUtility.numberToString(from: (tweetToDisplay?.favoriteCount)!)
                
                self.favouriteButton.setTitle("  \(numberInString)", for: .normal)
            }else{
                self.favouriteButton.setTitle("", for: .normal)
 
            }
            
            
            if (tweetToDisplay?.media != nil) {
                self.mediaImageHeightConstraint.constant = 145
                //(self.tweet?.media?.mediumSize?.height)!
                self.mediaImageView.setImageWith(URL(string:(tweetToDisplay?.media?.mediaURL)!)!)
                
            }else{
                self.mediaImageHeightConstraint.constant = 0

            }
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.userIconImageView.layer.cornerRadius = 0.5 * self.userIconImageView.frame.width
        replyButton.addTarget(self, action: #selector(replyButtonTapped), for: UIControlEvents.touchUpInside)
        retweetButton.addTarget(self, action: #selector(reTweetButtonTapped), for: UIControlEvents.touchUpInside)
        favouriteButton.addTarget(self, action: #selector(favButtonTapped), for: UIControlEvents.touchUpInside)

    }
    
    func replyButtonTapped() -> Void {
        
    }
    
    func reTweetButtonTapped() -> Void {
        
        if self.tweetCellDelegate != nil {
            self.tweetCellDelegate?.tweetCell!(cell: self, didTapOnRetweetButtonForTweet: self.tweet!)
        }
        
//        if let retweeted = self.tweet?.retweeted {
//            if retweeted == true {
//                self.tweet?.retweeted = false
//                if let count = self.tweet?.retweetedCount {
//                    self.tweet?.retweetedCount = count-1
//                }
//            }else{
//                self.tweet?.retweeted = true
//                if let count = self.tweet?.retweetedCount {
//                    self.tweet?.retweetedCount = count+1
//                }
//            }
//           updateRetweet()
//        }
        
    }
    
    func favButtonTapped() -> Void {
        if let favourited = self.tweet?.favourited {
            
            if favourited == true {
                self.tweet?.favourited =  false
                if let count = self.tweet?.favoriteCount {
                    self.tweet?.favoriteCount = count-1
                }
                
                TwitterClient.sharedInstance.removeFromFavourite(tweet: self.tweet, completion: { (tweet:Tweet?, error:Error?) in
                    if tweet != nil {
                        
                        TwitterClient.sharedInstance.unReTweet(tweet: self.tweet, completion: { (tweet : Tweet?,error: Error?) in
                            if tweet != nil {
                            }
                        })
                        
                    }
                })

            }else{
                self.tweet?.favourited = true
                if let count = self.tweet?.favoriteCount {
                    self.tweet?.favoriteCount = count+1
                }
                
                TwitterClient.sharedInstance.addToFavourite(tweet: self.tweet, completion: { (tweet:Tweet?, error:Error?) in
                    if tweet != nil {
                        TwitterClient.sharedInstance.unReTweet(tweet: self.tweet, completion: { (tweet : Tweet?,error: Error?) in
                            if tweet != nil {
                            }
                        })
                        
                    }
                })
            }
        updateFav()
            
            if self.tweetCellDelegate != nil {
                self.tweetCellDelegate?.tweetCell!(cell: self, didTapOnFavButtonForTweet: self.tweet!)
            }
            
        }
    }
    
    func updateFav(){
        let imageName = (self.tweet?.favourited)! ? "Favorite" : "Favorite_black"
        self.favouriteButton.setImage(UIImage(named:imageName), for: UIControlState.normal)
        if (tweet?.favoriteCount)!>0 {
            self.favouriteButton.setTitle("  \(tweet?.favoriteCount ?? 0)", for: .normal)
        }else{
            self.favouriteButton.setTitle("", for: .normal)
            
        }
    }
    
    func updateRetweet() {
        let imageName = (self.tweet?.retweeted)! ? "Retweet_green" : "Retweet_black"
        self.retweetButton.setImage(UIImage(named:imageName), for: UIControlState.normal)
        if (tweet?.retweetedCount)!>0 {
            self.retweetButton.setTitle(" \(tweet?.retweetedCount ?? 0)", for: .normal)
            
        }else {
            self.retweetButton.setTitle("", for: .normal)
            
        }
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
