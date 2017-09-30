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
    
    @IBOutlet weak var retweetLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var retweetImgConstraint: NSLayoutConstraint!
    var tweet: Tweet? {
        didSet {
            
            self.retweetLabelHeightConstraint.constant = 0
            self.retweetImgConstraint.constant = 0
            
            
            self.userNameLabel.text = tweet?.user?.name
            if let imgURL = tweet?.user?.profileImageUrl {
                self.userIconImageView.setImageWith(NSURL(string:imgURL)! as URL)
            }
            self.tweetTextView.text = tweet?.text
            self.userTweetHandlerLabel.text = "@"+(tweet?.user?.screenName)!
            
            let date = tweet?.createdAt
            let dateInStr = date?.timeAgo()
            self.tweetTimeLabel.text = dateInStr
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.userIconImageView.layer.cornerRadius = 0.5 * self.userIconImageView.frame.width
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
