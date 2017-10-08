//
//  AppDelegate.swift
//  Twitter
//
//  Created by Kaushik on 9/26/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        window = UIWindow.init(frame: UIScreen.main.bounds)
        NotificationCenter.default.addObserver(self, selector: #selector(userDidLogout), name:
            NSNotification.Name(rawValue: userDidLogoutNotification), object: nil)
        
        let vc = storyBoard.instantiateViewController(withIdentifier: "tweetsViewController")
        let navController = UINavigationController(rootViewController: vc)
//        let tabBarController  = UITabBarController.init()
//        tabBarController.viewControllers = [navController]
        
        
        let hamburgerViewController = self.window?.rootViewController as! HamburgerViewController
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuViewController = storyboard.instantiateViewController(withIdentifier: "menuViewController") as! MenuViewController
        hamburgerViewController.menuViewController = menuViewController
        menuViewController.hamburgerViewController = hamburgerViewController
        hamburgerViewController.contentViewController = navController
//        window?.rootViewController = hamburgerViewController
//        window?.becomeKey()
        
        //print("\(self.window?.rootViewController)")

        
        // Override point for customization after application launch.
        if User.currentUser == nil {
            print("current user detected \(User.currentUser?.name)")
            
            showLoginViewController()
        }else{
            
        }
        return true
    }
    
    func userDidLogout() {
//        let vc = storyBoard.instantiateInitialViewController()
//        window?.rootViewController = vc
        showLoginViewController()
    }
    
    func showLoginViewController() -> Void {
//        let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginViewController") as! ViewController
//        let vc = self.window?.rootViewController
//
//        vc?.present(loginViewController, animated: true, completion: { 
//            
//        })
        
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        TwitterClient.sharedInstance.openURL(url: url as NSURL)
        
        return true
    }


}

