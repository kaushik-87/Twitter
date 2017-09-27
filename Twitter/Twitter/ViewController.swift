//
//  ViewController.swift
//  Twitter
//
//  Created by Kaushik on 9/26/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogin(_ sender: Any) {
        TwitterClient.sharedInstance.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string : "kttwitterdemo://oauth")! as URL, scope: nil, success: { ( requestToken : BDBOAuth1Credential?) in
            if let token = requestToken {
                if let authURL = NSURL(string:"https://api.twitter.com/oauth/authorize?oauth_token=\(token.token!)") {
                    UIApplication.shared.open(authURL as URL, options: ["" : ""], completionHandler: { (Success : Bool) in
                        
                    })
                }

            }
            //let authURL = NSURL (string: )
            //UIApplication.shared.open(authURL! as URL, options: ["" : ""], completionHandler: { (Success : Bool) in
            
            //})
            
        }) { (Error : Error?) in
            
            
        }
    }

}

