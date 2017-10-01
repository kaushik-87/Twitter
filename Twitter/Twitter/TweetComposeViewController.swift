//
//  TweetComposeViewController.swift
//  Twitter
//
//  Created by Kaushik on 9/30/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit

enum TweetMode {
    case tweetModeReply
    case tweetModeCompose
}
let totalCharactersCount = 140

@objc protocol TweetComposeViewControllerDelegate {
    @objc optional func tweetComposeViewController(viewController: TweetComposeViewController, didPostNewTweet: Tweet)
    @objc optional func tweetComposeViewController(viewController: TweetComposeViewController, didPostReplyTweet: Tweet)

}

class TweetComposeViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var composeTextView: UITextView!
    @IBOutlet weak var replyToTweetHandlerLabel: UILabel!
    @IBOutlet weak var composePlaceholderLabel: UILabel!
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var bottomComposeView: UIView!
    @IBOutlet weak var tweetCharacterCountLabel: UILabel!
    @IBOutlet weak var replyDetailsStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewBaseConstraint: NSLayoutConstraint!

    weak var composeTweetDelegate : TweetComposeViewControllerDelegate?
    var currentTweetMode : TweetMode = .tweetModeCompose
    var currentTweet : Tweet?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        loadComposeView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tweetCharacterCountLabel.text = "\(totalCharactersCount)"
        self.tweetButton.layer.cornerRadius = 0.5 * self.tweetButton.frame.size.height
        self.composeTextView.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: Notification.Name("UIKeyboardDidShowNotification"), object: nil)

    }

    @IBAction func postTweet(_ sender: Any) {
        switch self.currentTweetMode {
        case .tweetModeCompose:
            TwitterClient.sharedInstance.postNewTweet(newTweetText: self.composeTextView.text) { (tweet: Tweet?, error: Error?) in
                if tweet != nil {
                    if self.composeTweetDelegate != nil {
                        self.composeTweetDelegate?.tweetComposeViewController!(viewController: self, didPostNewTweet: tweet!)
                    }
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: {
                        })
                    }
                }
            }
            break
        case .tweetModeReply:
            TwitterClient.sharedInstance.postReply(tweetText: self.composeTextView.text, toTweet: self.currentTweet!, completion: { (tweet: Tweet?, error: Error?) in
                if tweet != nil {
                    DispatchQueue.main.async {
                        let userInfo = [Notification.Name("Tweet"): tweet!]
                        let didSendReplyNotification = Notification(name: Notification.Name("didSendReplyTweetNotification"), object: self, userInfo: userInfo)
                        NotificationCenter.default.post(didSendReplyNotification)
                        self.dismiss(animated: true, completion: {
                        })
                    }
                }                
            })
            break
        default:
            break
            
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("UIKeyboardDidShowNotification"), object: nil)
    }
    
    func keyboardDidShow(notification: Notification){
        if let keyboardRect = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            let keyboardHeight = keyboardRect.height
            UIView.animate(withDuration: 0.3, animations: {
                self.bottomComposeView.frame.origin.y = self.bottomComposeView.frame.origin.y - keyboardHeight
                self.bottomViewBaseConstraint.constant = keyboardHeight
            })
        }
    }
    
    @IBAction func cancelComposing(_ sender: Any) {
        
        self.composeTextView.resignFirstResponder()
        self.dismiss(animated: true) {
        
        }
    }
    func replyForTweet(tweet: Tweet?) -> Void {
        if tweet != nil {
            self.currentTweetMode = .tweetModeReply
            self.currentTweet = tweet
        }else{
            self.currentTweetMode = .tweetModeCompose
            self.currentTweet = nil
        }
    }
    
    func loadComposeView() -> Void {
        switch self.currentTweetMode {
        case .tweetModeCompose:
            self.replyDetailsStackViewHeightConstraint.constant = 0
            self.composePlaceholderLabel.text = "What's happening?"
            break
        case .tweetModeReply:
            self.replyDetailsStackViewHeightConstraint.constant = 15.5
            self.composePlaceholderLabel.text = "Tweet your reply"
            self.replyToTweetHandlerLabel.text = "@"+(self.currentTweet?.user?.screenName)!
            break
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        return true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
//        self.composePlaceholderLabel.isHidden = true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateUI()
    }
    
    func updateUI() -> Void {
        
        let currentCount = self.composeTextView.text.characters.count
        self.composePlaceholderLabel.isHidden = currentCount>0 ? true : false
        self.tweetButton.isEnabled = currentCount>totalCharactersCount ? false : true
        self.tweetCharacterCountLabel.text = "\(totalCharactersCount - currentCount)"
        
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
