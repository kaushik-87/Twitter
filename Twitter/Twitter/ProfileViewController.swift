//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Kaushik on 10/6/17.
//  Copyright © 2017 Dev. All rights reserved.
//

import UIKit
let offset_HeaderStop:CGFloat = 40.0 // At this offset the Header stops its transformations
let offset_B_LabelHeader:CGFloat = 95.0 // At this offset the Black label reaches the Header
let distance_W_LabelHeader:CGFloat = 35.0 // The distance between the bottom of the Header and the top of the White Label

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
    var tweets : [Tweet]?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tweets = [Tweet]()
        self.profileImageView.layer.cornerRadius = 0.5 * self.profileImageView.frame.size.width
        self.profileImageView.layer.borderWidth = 4
        self.profileImageView.layer.borderColor = UIColor.white.cgColor
        self.profileImageView.clipsToBounds = true
        let nib = UINib(nibName: "TweetCell", bundle: nil)
        self.profileTableView.register(nib, forCellReuseIdentifier: "tweetCell")
        self.profileTableView.estimatedRowHeight = self.profileTableView.rowHeight
        self.profileTableView.rowHeight = UITableViewAutomaticDimension
        loadViewForUserProfile(user: currentUser)
        loadUserTweets()

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
        self.profileHeaderView.layoutIfNeeded()
//        self.profileHeaderView.frame.size = self.profileHeaderView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
//        self.profileTableView.tableHeaderView = self.profileHeaderView
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        // The table view header is created with the frame size set in
        // the Storyboard. Calculate the new size and reset the header
        // view to trigger the layout.
        // Calculate the minimum height of the header view that allows
        // the text label to fit its preferred width.
        
        let size = self.profileHeaderView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)

        let newSize = CGSize(width: size.width, height: size.height + self.descriptionScrollView.contentSize.height + 20)
        
        if self.profileHeaderView.frame.size.height != newSize.height {
            self.profileHeaderView.frame.size.height = newSize.height
            
            // Need to set the header view property of the table view
            // to trigger the new layout. Be careful to only do this
            // once when the height changes or we get stuck in a layout loop.
            self.profileTableView.tableHeaderView = self.profileHeaderView
            
            // Now that the table view header is sized correctly have
            // the table view redo its layout so that the cells are
            // correcly positioned for the new header size.
            // This only seems to be necessary on iOS 9.
            self.profileTableView.layoutIfNeeded()
        }
    }
    
    
    
    func  loadProfileDetailsFor(user : User?) -> Void {
        
//        if let imgURL = user?.profileImageUrl {
//            self.profileImageView.setImageWith(NSURL(string:imgURL)! as URL)
//        }
    }
    
    
    func loadUserTweets() -> Void {
        TwitterClient.sharedInstance.fetchUserTweetsTimeline(user: currentUser) { (tweets: [Tweet]?, error: Error?) in
            if tweets != nil {
                DispatchQueue.main.async {
                    self.tweets = tweets
                    self.profileTableView.reloadData()
                }
            }
            else{
                
            }
        }
    }

    func loadUserTweetsWithMedia() -> Void {
        
    }
    
    func loadUserTweetsWithLikes() -> Void {
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.tweets?.count)!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
        headerView.backgroundColor = UIColor.white
        let segmentControl = UISegmentedControl(items: ["Tweets", "Mentions", "Likes"])
        segmentControl.frame = headerView.bounds
        segmentControl.backgroundColor = UIColor.white
        segmentControl.tintColor = UIColor(red:0.00, green:0.52, blue:0.71, alpha:1.0)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.center = headerView.center
        segmentControl.addTarget(self, action: #selector(segmentSelectionChanged(_:)), for: .valueChanged)
        segmentControl.removeBorders()
        headerView.addSubview(segmentControl)
        return headerView
    }
    func segmentSelectionChanged(_ sender: UISegmentedControl) -> Void {
        print("\(sender.selectedSegmentIndex)")
        switch sender.selectedSegmentIndex {
        case 1:
            loadUserTweetsWithMedia()
            break
        case 2:
            loadUserTweetsWithLikes()
            break
        default:
            // in case of segment 0
            loadUserTweets()
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        if (self.tweets?.count)!>0 {
            cell.tweet = self.tweets?[indexPath.row]
        }
        return cell
    }
    
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("Scroll offset \(scrollView.contentOffset.y)")
        var avatarTransform = CATransform3DIdentity
        var headerTransform = CATransform3DIdentity
        if scrollView.contentOffset.y <= 0{
            self.topSpaceConstraint.constant = scrollView.contentOffset.y 
            self.bannerImageHeightConstraint.constant = self.bannerImageOriginalHeight - scrollView.contentOffset.y
            
            
            
//            print("\(self.bannerImageHeightConstraint.constant)")
            self.profileHeaderView.layoutIfNeeded()
            
           //(scrollView.contentOffset.y >= -18)
        }else  {
            let avatarScaleFactor = (min(offset_HeaderStop, scrollView.contentOffset.y)) / self.profileImageView.bounds.height / 1.4 // Slow down the animation
            print("scale factor \(avatarScaleFactor)")
            let avatarSizeVariation = ((self.profileImageView.bounds.height * (1.0 + avatarScaleFactor)) - self.profileImageView.bounds.height) / 2.0
            
            print("Variation \(avatarScaleFactor)")

            avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0)
            avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0)
        }
        
         self.profileImageView.layer.transform = avatarTransform
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


extension UISegmentedControl {
    func removeBorders() {
        setBackgroundImage(imageWithColor(color: backgroundColor!), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: tintColor!), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}


