//
//  AccountsViewController.swift
//  Twitter
//
//  Created by Kaushik on 10/8/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit

class AccountsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountsCell", for: indexPath) as! AccountsCell
        if indexPath.row == AccountsManager.sharedInstance.accounts.count {
            cell.addAcountLabel.isHidden = false
            cell.profileImageView.isHidden = true
            cell.profileName.isHidden = true
            cell.profileScreenName.isHidden = true
            return cell
        }
        cell.addAcountLabel.isHidden = true
        cell.profileImageView.isHidden = false
        cell.profileName.isHidden = false
        cell.profileScreenName.isHidden = false
        let user = AccountsManager.sharedInstance.accounts[indexPath.row]
        cell.profileName.text = user.name
        cell.profileScreenName.text = "@"+(user.screenName)!
        if let imgURL = user.profileImageUrl {
            cell.profileImageView.clipsToBounds = true
            cell.profileImageView.layer.cornerRadius = 0.5 * cell.profileImageView.frame.size.width
            cell.profileImageView.setImageWith(NSURL(string:imgURL)! as URL)
        }
        cell.profileScreenName.text = AccountsManager.sharedInstance.accounts[indexPath.row].screenName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == AccountsManager.sharedInstance.accounts.count {
            addNewAccount()
            return
        }
        let user = AccountsManager.sharedInstance.accounts[indexPath.row]
        AccountsManager.sharedInstance.switchCurrentUserTo(user: user)
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AccountsManager.sharedInstance.accounts.count + 1
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Logout"
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if indexPath.row == AccountsManager.sharedInstance.accounts.count {
            return .none
        }
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let user = AccountsManager.sharedInstance.accounts[indexPath.row]
            AccountsManager.sharedInstance.logOutUser(user: user)
            tableView.reloadData()
            return
        }
    }

//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        
//    }
    
    @IBOutlet weak var accountsTableView: UITableView!
    
    
    func addNewAccount() -> Void {
        
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.loginWithCompletion { (user: User?, error: Error?) in
            print("\(user?.name)")
            AccountsManager.sharedInstance.addUserToAccounts(user: user!)
            AccountsManager.sharedInstance.currentActiveUser = user
            self.accountsTableView.reloadData()
            self.navigationController?.popViewController(animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.accountsTableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(accountsDidSwitchAccount), name:
            NSNotification.Name(rawValue: accountManagerDidSwitchUserNotification), object: nil)
        
    }

    
    func accountsDidSwitchAccount() -> Void {
        self.navigationController?.popToRootViewController(animated: true)
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
