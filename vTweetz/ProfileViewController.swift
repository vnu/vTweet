//
//  ProfileViewController.swift
//  vTweetz
//
//  Created by Vinu Charanya on 2/27/16.
//  Copyright © 2016 vnu. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {


    @IBOutlet weak var profileBgImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var websiteLinkLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    
    @IBOutlet weak var tweetsSeparatorView: UIView!
    
    @IBOutlet weak var profileContentView: UIView!

    var tweetsTableView: TweetzTableView!
    
    var user: User!
    var tweets = [Tweet]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = User.currentUser
        setUserInfo()
        initTweetsTable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func setUserInfo(){
        nameLabel.text = user.name
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
    }
    
    func initTweetsTable(){
        print("Came here added something")
        if let tweetsTblView = NSBundle.mainBundle().loadNibNamed("TweetzTableView", owner: self, options: nil).first as? TweetzTableView {
            tweetsTableView = tweetsTblView
            tweetsTableView.initView("user_timeline.json")
            tweetsTableView.translatesAutoresizingMaskIntoConstraints = false
            profileContentView.addSubview(tweetsTableView)
            setConstraints()
            tweetsTableView.fetchTweets()
        }
    }
    
    func setConstraints(){
        let views = ["separatorView": self.tweetsSeparatorView, "tableView": self.tweetsTableView]
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[tableView]-0-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: views)
        profileContentView.addConstraints(horizontalConstraints)
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[separatorView]-0-[tableView]-0-|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: views)
        profileContentView.addConstraints(verticalConstraints)
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