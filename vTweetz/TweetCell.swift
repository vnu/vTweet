//
//  TweetTableViewCell.swift
//  vTweetz
//
//  Created by Vinu Charanya on 2/20/16.
//  Copyright © 2016 vnu. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetedAtLabel: UILabel!
    @IBOutlet weak var tweetActionImage: UIImageView!
    @IBOutlet weak var tweetActionLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    
    let retweetImage = UIImage(named: "retweet-action-on")
    let unretweetImage = UIImage(named: "retweet-action")
    let likeImage = UIImage(named: "like-action-on")
    let unlikeImage = UIImage(named: "like-action")
    
    
    
    var tweet: Tweet!{
        didSet{
            nameLabel.text = tweet.user!.name!
            screenNameLabel.text = "@\(tweet.user!.screenName!)"
            tweetedAtLabel.text = tweet.tweetedAt!
            tweetTextLabel.text = tweet.text!
            retweetLabel.text = "\(tweet.retweetCount!)"
            likeLabel.text = "\(tweet.likeCount!)"
            profileImage.setImageWithURL(NSURL(string: (tweet.user?.profileImageUrl)!)!)
            setLikeImage(!tweet.liked!)
            setRetweetImage(!tweet.retweeted!)
        }
    }
    
    func setRetweetImage(retweeted: Bool){
        if retweeted{
            self.retweetButton.setImage(unretweetImage, forState: .Normal)
        }else{
            self.retweetButton.setImage(retweetImage, forState: .Normal)
        }
    }
    
    func setLikeImage(liked: Bool){
        if liked{
            self.likeButton.setImage(unlikeImage, forState: .Normal)
        }else{
            self.likeButton.setImage(likeImage, forState: .Normal)
        }
    }
    
    
    @IBAction func onRetweet(sender: AnyObject) {
        if let retweeted = tweet.retweeted{
            if retweeted{
                self.retweetLabel.text = "\(Int(self.retweetLabel.text!)! - 1)"
            }else{
                self.retweetLabel.text = "\(Int(self.retweetLabel.text!)! + 1)"
            }
            setRetweetImage(retweeted)
        }
        tweet.retweet()
    }
    
    @IBAction func onLike(sender: AnyObject) {
        if let liked = tweet.liked{
            if liked{
                self.likeLabel.text = "\(Int(self.likeLabel.text!)! - 1)"
            }else{
                self.likeLabel.text = "\(Int(self.likeLabel.text!)! + 1)"
            }
            setLikeImage(liked)
        }

        tweet.like()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
