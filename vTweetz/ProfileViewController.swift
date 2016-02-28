//
//  ProfileViewController.swift
//  vTweetz
//
//  Created by Vinu Charanya on 2/27/16.
//  Copyright © 2016 vnu. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, TweetCellDelegate {


    @IBOutlet weak var profileBgImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var websiteLinkLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    
    @IBOutlet weak var tweetsSeparatorView: UIView!
    
    @IBOutlet weak var tweetsView: UIView!
    var tweetsTableView: TweetzTableView!
    
    var user = User.currentUser!
    var tweets = [Tweet]()
    
    var parameters = [String:String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTweetsTable()
        refreshViewData()
        tweetsTableView.delegate = self
        tweetsTableView.setCellDelegate(self)
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func refreshViewData(){
        nameLabel.text = user.name
        parameters["screen_name"] = user.screenName!
        screenNameLabel.text = "@\(user.screenName!)"
        if let profileBgImageUrl = user.profileBgImageUrl{
            profileBgImage.setImageWithURL(NSURL(string: profileBgImageUrl)!)
        }else{
            profileBgImage.backgroundColor = UIColor(hexString: "2B7BB9")
        }
        if let profileImageUrl = user.profileImageUrl{
            profileImage.setImageWithURL(NSURL(string: profileImageUrl)!)
        }
        locationLabel.text = user.location
        websiteLinkLabel.text = user.expandedUrl
        followingLabel.text = "\(user.friendsCount!)"
        followersLabel.text = "\(user.followersCount!)"
        showTweetsWith("user_timeline.json?screen_name=\(user.screenName!)")
    }
    
    func showTweetsWith(endpoint: String){
        tweetsTableView.fetchEndpoint = endpoint
        tweetsTableView.fetchTweets(parameters)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!tweetsTableView.isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            
            let scrollViewContentHeight = tweetsTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - (tweetsTableView.bounds.size.height)
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tweetsTableView.dragging && !tweetsTableView.reachedAPILimit) {
                tweetsTableView.isMoreDataLoading = true
                tweetsTableView.loadMoreTweets(parameters)
            }
        }
    }
    
    func initTweetsTable(){
        if let tweetsTblView = NSBundle.mainBundle().loadNibNamed("TweetzTableView", owner: self, options: nil).first as? TweetzTableView {
            tweetsTableView = tweetsTblView
            tweetsTableView.initView()
            tweetsView.addSubview(tweetsTableView)
            setConstraints()
        }
    }
    
    func setConstraints(){
        let views = ["tweetsView": self.tweetsView, "tableView": self.tweetsTableView]
        tweetsTableView.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[tableView]-0-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: views)
        tweetsView.addConstraints(horizontalConstraints)
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(-40)-[tableView]-0-|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: views)
        tweetsView.addConstraints(verticalConstraints)
    }
    
    func tweetCell(tweetCell: TweetCell, onProfileImageTap value: Tweet) {
        print("Came here to profit")
        self.user = value.user!
        self.refreshViewData()
    }
    

    
    //Tweets Buttons
    
    @IBAction func onTweetsTap(sender: UIButton) {
        showTweetsWith("user_timeline.json?screen_name=\(user.screenName!)")
    }
    
    
    @IBAction func onMediaTap(sender: UIButton) {
        showTweetsWith("mentions_timeline.json")
    }
    
    
    @IBAction func onLikesTap(sender: UIButton) {
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
