//
//  HamburgerViewController.swift
//  Twitter
//
//  Created by Kaushik on 10/6/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var menuView: UIView!
    var originalLeftMargin: CGFloat!
    
    var menuViewController: UIViewController! {
        didSet {
            view.layoutIfNeeded()
            menuView.addSubview(menuViewController.view)
        }
    }
    
    var contentViewController: UIViewController! {
        didSet {
            view.layoutIfNeeded()
            contentView.addSubview(contentViewController.view)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDidLogout), name:
            NSNotification.Name(rawValue: userDidLogoutNotification), object: nil)
        
        if User.currentUser == nil {

            //self.present(loginViewController, animated: true, completion: nil)
        }

        // Do any additional setup after loading the view.
    }
    
    func userDidLogout() -> Void {
        closeMenu()

    }

    @IBAction func onPangesture(_ sender: UIPanGestureRecognizer) {
        
        print("\(UIApplication.shared.keyWindow?.rootViewController)")

        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == .began {

            originalLeftMargin = leftMarginConstraint.constant
            
        } else if sender.state == .changed {

            if (leftMarginConstraint.constant > originalLeftMargin && velocity.x < 0) {
                leftMarginConstraint.constant = originalLeftMargin + translation.x

            }else if (velocity.x > 0) {
                leftMarginConstraint.constant = originalLeftMargin + translation.x

            }
            
        } else if sender.state == .ended {
            
            UIView.animate(withDuration: 0.3, animations: { 
                if velocity.x > 0 {
                    self.leftMarginConstraint.constant = self.view.frame.size.width - 50
                }else {
                    self.leftMarginConstraint.constant = 0
                }
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func openMenu() -> Void {
        UIView.animate(withDuration: 0.3, animations: {
                self.leftMarginConstraint.constant = self.view.frame.size.width - 50
                        self.view.layoutIfNeeded()
        })
    }
    
    func closeMenu() -> Void {

        UIView.animate(withDuration: 0.3, animations: {
            self.leftMarginConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
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
