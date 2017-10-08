//
//  MenuViewController.swift
//  Twitter
//
//  Created by Kaushik on 10/6/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuCell
        if menuDataSource.count>0 {
            if  menuDataSource[indexPath.row]["name"] != "" {
                cell.cellLabel.text = menuDataSource[indexPath.row]["name"]
                if let image = menuDataSource[indexPath.row]["imageName"] {
                    cell.cellImageView.image = UIImage(named: image)

                }
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = menuDataSource.count>0 ? menuDataSource.count : 0
        return count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            loadProfileDetials()
            break
        case 1:
            loadMentions()

//            loadHomeTimeLine()
            break
        case 2:
            loadAccounts()

            break
        case 3:
            break
        default:
            break
        }
    }
    
    func loadProfileDetials() -> Void {
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
    
    func loadHomeTimeLine() -> Void {
        
    }
    
    func loadMentions() -> Void {
        
        hamburgerViewController?.closeMenu()
        
        if User.currentUser != nil {
            if let navController = hamburgerViewController?.contentViewController as? UINavigationController {
                let mentionsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MentionsViewController") as! MentionsViewController
                navController.pushViewController(mentionsViewController, animated: true)
                //                profileViewController.loadProfileDetailsFor(user : User.currentUser)
            }
        }
        
    }
    
    func loadAccounts() -> Void {
//         User.currentUser?.logout()
        hamburgerViewController?.closeMenu()

        
        if let navController = hamburgerViewController?.contentViewController as? UINavigationController {
            let accountsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AccountsViewController") as! AccountsViewController
            navController.pushViewController(accountsViewController, animated: true)
//            accountsViewController.currentUser = User.currentUser
            //                profileViewController.loadProfileDetailsFor(user : User.currentUser)
        }
        
        
    }
    

    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var profileScreenName: UILabel!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    var menuDataSource = [["":""]]
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
        // ["imageName": "home" , "name" : "Home Timeline"],
        NotificationCenter.default.addObserver(self, selector: #selector(userDidLogin), name:
            NSNotification.Name(rawValue: userDidLoginNotification), object: nil)
        if User.currentUser != nil {
            loadMenuViewForUser()
        }

        NotificationCenter.default.addObserver(self, selector: #selector(accountsDidSwitchAccount), name:
            NSNotification.Name(rawValue: accountManagerDidSwitchUserNotification), object: nil)
        

        // Do any additional setup after loading the view.
        
    }
    
    
    
    func accountsDidSwitchAccount() -> Void {
        loadMenuViewForUser()
        
    }
    
    func userDidLogin() -> Void {
        
        loadMenuViewForUser()
    }
    
    func loadMenuViewForUser() -> Void {
        self.profileName.text = User.currentUser?.name
        self.profileScreenName.text = "@"+(User.currentUser?.screenName)!
        if let imgURL = User.currentUser?.profileImageUrl {
            self.profileImageView.clipsToBounds = true
            self.profileImageView.layer.cornerRadius = 0.5 * self.profileImageView.frame.size.width
            self.profileImageView.setImageWith(NSURL(string:imgURL)! as URL)
        }
        menuDataSource = [["imageName": "Profile" , "name" : "Profile"], ["imageName": "Mentions" , "name" : "Mentions"], ["imageName": "Accounts" , "name" : "Accounts"]]
        self.menuTableView.reloadData()
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
