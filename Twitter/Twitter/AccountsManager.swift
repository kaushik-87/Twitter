//
//  AccountsManager.swift
//  Twitter
//
//  Created by Kaushik on 10/8/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit

let accountManagerDidSwitchUserNotification = "accountsManagerDidSwitchUser"
let accountManagerDidLogoutUserNotification = "accountManagerDidLogoutUser"
let accountManagerNoLoggedInUsersNotification = "accountManagerNoLoggedInUsers"

class AccountsManager: NSObject {
    class var sharedInstance : AccountsManager {
        struct Static {
            static let instance = AccountsManager.init()
        }
        NotificationCenter.default.addObserver(Static.instance, selector: #selector(userDidLogout), name:NSNotification.Name(rawValue: userDidLogoutNotification), object: nil)

        return Static.instance
    }

    var accounts = [User]()
    var currentActiveUser : User? {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: accountManagerDidSwitchUserNotification), object: nil)
        }
    }
    
    func saveAccessTokenForUser(user: User, accessToken: String) -> Void {
        
    }
    
    func accessTokenForUser(user: User) -> String {
        return ""
    }
    
    func addUserToAccounts(user: User) -> Void {
        if !self.accounts.contains(user) {
            self.accounts.append(user)
            switchCurrentUserTo(user: user)
        }

    }
    
    func removeUserFromAccounts(user: User) -> Void {
        if let index = self.accounts.index(of: user) {
            self.accounts.remove(at: index)
        }
    }
    
    func userDidLogout(){
        if AccountsManager.sharedInstance.accounts.count>0 {
            AccountsManager.sharedInstance.removeUserFromAccounts(user: currentActiveUser!)
            if AccountsManager.sharedInstance.accounts.count>0 {
                let user1 = AccountsManager.sharedInstance.accounts[0]
                switchCurrentUserTo(user: user1)
            }else{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: accountManagerNoLoggedInUsersNotification), object: nil)
 
            }
        }
    }
    
    func logOutUser(user: User) -> Void {
        user.logout()
    }
    
    func switchCurrentUserTo(user: User) -> Void {
        TwitterClient.sharedInstance.requestSerializer.saveAccessToken(user.bdbAccessCredential)
        User.currentUser = user
        self.currentActiveUser = user
       
    }
    
    func allAccounts() -> [User] {
        return [User.currentUser!]
    }
    
    
}
