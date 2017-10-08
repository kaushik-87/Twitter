//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Kaushik on 10/6/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var verifiedAccountImageView: UIImageView!
    @IBOutlet weak var profileBannerImageView: UIImageView!
    @IBOutlet weak var profileScreenNameLabel: UILabel!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptionPageControl: UIPageControl!
    
    @IBOutlet weak var descriptionScrollView: UIScrollView!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!

    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var profileHeaderView: UIView!
    @IBOutlet weak var bannerImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topSpaceConstraint: NSLayoutConstraint!
    
    var currentUser : User?
    var bannerImageOriginalHeight: CGFloat = 95
    var isViewDidAppear = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadViewForUserProfile(user: currentUser)

    }

    @IBAction func pageControlChanged(_ sender: UIPageControl) {
        print("\(self.descriptionScrollView.contentOffset)")
        let contentOffSetX = sender.currentPage == 1 ? self.descriptionScrollView.contentSize.width - self.descriptionScrollView.frame.size.width : 0.0
        let imgopacity = sender.currentPage == 1 ? 0.5 : 1.0
        self.profileBannerImageView.layer.opacity = Float(imgopacity)
        let contentOffSetPoint = CGPoint(x: contentOffSetX, y: 0.0)
        self.descriptionScrollView.setContentOffset(contentOffSetPoint, animated: true)
    }
    
    func loadViewForUserProfile(user : User?) -> Void {
        if let imgURL = currentUser?.profileImageUrl {
            self.profileImageView.setImageWith(NSURL(string:imgURL)! as URL)
        }
        
        if let bannerImgURL = currentUser?.profileBannerURL {
            self.profileBannerImageView.setImageWith(NSURL(string:bannerImgURL)! as URL)
        }
        
        self.verifiedAccountImageView.isHidden = (currentUser?.verifiedAccount)! ? false : true
        let followersCountInstring = TweeterUtility.numberToString(from: (currentUser?.followersCount)!)
        let followingCountInstring = TweeterUtility.numberToString(from: (currentUser?.followingCount)!)
        
        self.followersCountLabel.text = followersCountInstring
        self.followingCountLabel.text = followingCountInstring
        
        self.profileNameLabel.text = currentUser?.name
        self.profileScreenNameLabel.text = "@" + (currentUser?.screenName)!
        
        if currentUser?.profileDescription != "" {
            self.descriptionPageControl.isHidden = false
            self.descriptionTextView.text = currentUser?.profileDescription
            self.descriptionScrollView.isScrollEnabled = true
        }else {
            self.descriptionPageControl.isHidden = true
            self.descriptionTextView.text = ""
            self.descriptionScrollView.isScrollEnabled = false
        }
        
        
        self.tweetsCountLabel.isHidden = true
        
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//            self.bannerImageOriginalHeight = 95
//            self.bannerImageHeightConstraint.constant = self.bannerImageOriginalHeight
//        App.postStatusBarShouldUpdateNotification(style: .lightContent)
//        self.navigationController?.isNavigationBarHidden = true;

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !self.isViewDidAppear{
            self.isViewDidAppear = true
//        self.profileHeaderView.setNeedsLayout()
//        self.profileHeaderView.layoutIfNeeded()
//        self.profileHeaderView.frame.size = self.profileHeaderView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
//        self.profileTableView.tableHeaderView = self.profileHeaderView
        }
        
    }
    
    func  loadProfileDetailsFor(user : User?) -> Void {
        
//        if let imgURL = user?.profileImageUrl {
//            self.profileImageView.setImageWith(NSURL(string:imgURL)! as URL)
//        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath)
        return cell
    }
    
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0{
            self.topSpaceConstraint.constant = scrollView.contentOffset.y 
        print("Scroll offset \(scrollView.contentOffset.y)")
            self.bannerImageHeightConstraint.constant = self.bannerImageOriginalHeight - scrollView.contentOffset.y
            
            print("\(self.bannerImageHeightConstraint.constant)")
            self.profileHeaderView.layoutIfNeeded()
        }
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
