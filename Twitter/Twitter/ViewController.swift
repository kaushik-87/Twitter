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
        
        TwitterClient.sharedInstance.loginWithCompletion { (user : User?, error : Error?) in
            
            if user != nil {
                
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            }else {
                
            }
            
        }

    }

}

