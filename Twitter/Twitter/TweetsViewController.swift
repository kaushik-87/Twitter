//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Kaushik on 9/28/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {

    var tweets : [Tweet]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TwitterClient.sharedInstance.homeTimelineWithParams(params: nil) { (tweets:[Tweet]?,err: Error?) in
            self.tweets = tweets
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
