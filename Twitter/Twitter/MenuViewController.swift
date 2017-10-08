//
//  MenuViewController.swift
//  Twitter
//
//  Created by Kaushik on 10/6/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBAction func logOut(_ sender: Any) {
        User.currentUser?.logout()
    }
    @IBAction func profileDetails(_ sender: Any) {
        hamburgerViewController?.closeMenu()
        
        if User.currentUser != nil {
            if let navController = hamburgerViewController?.contentViewController as? UINavigationController {
                let profileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileViewController") as! ProfileViewController
                navController.pushViewController(profileViewController, animated: true)
                profileViewController.currentUser = User.currentUser
//                profileViewController.loadProfileDetailsFor(user : User.currentUser)
            }
        }
    }

    @IBOutlet weak var action: UIButton!
    
    var hamburgerViewController: HamburgerViewController?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
