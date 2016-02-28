//
//  TweetTableViewCell.swift
//  vTweetz
//
//  Created by Vinu Charanya on 2/20/16.
//  Copyright © 2016 vnu. All rights reserved.
//

import UIKit
import ActiveLabel

@objc protocol TweetCellDelegate {
    optional func tweetCell(tweetCell: TweetCell, onTweetReply value: Tweet)
    optional func tweetCell(tweetCell: TweetCell, onProfileImageTap value: Tweet)
}

class TweetCell: UITableViewCell {
    
    weak var delegate: TweetCellDelegate?
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetedAtLabel: UILabel!
    @IBOutlet weak var tweetActionImage: UIImageView!
    @IBOutlet weak var tweetActionLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: ActiveLabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    
    @IBOutlet weak var tweetActionView: UIStackView!
    
    
    @IBOutlet weak var mediaImage: UIImageView!
    @IBOutlet weak var imageMediaHeightConstraint: NSLayoutConstraint!
    let retweetImage = UIImage(named: "retweet-action-on")
    let unretweetImage = UIImage(named: "retweet-action")
    let likeImage = UIImage(named: "like-action-on")
    let unlikeImage = UIImage(named: "like-action")
    let replyImage = UIImage(named: "reply-action_0")
    
    
    var tweet: Tweet!{
        didSet{
            nameLabel.text = tweet.user!.name!
            screenNameLabel.text = "@\(tweet.user!.screenName!)"
            tweetedAtLabel.text = tweet.tweetedAt!
            retweetLabel.text = "\(tweet.retweetCount!)"
            likeLabel.text = "\(tweet.likeCount!)"
            profileImage.setImageWithURL(NSURL(string: (tweet.user?.profileImageUrl)!)!)
            setLikeImage(!tweet.liked!)
            setRetweetImage(!tweet.retweeted!)
            setTweetText()
            setTweetAction()
            addMediaImage()
        }
    }
    
    func addMediaImage(){
        if let mediaUrl = tweet.mediaUrl{
            mediaImage.setImageWithURL(NSURL(string: mediaUrl)!)
            mediaImage.hidden = false
            mediaImage.clipsToBounds = true
            imageMediaHeightConstraint.constant = 240
        }else{
            mediaImage.hidden = true
            imageMediaHeightConstraint.constant = 0
        }
    }
    
    func setTweetAction(){
        if let retweetBy = tweet.retweetedBy{
            tweetActionView.hidden = false
            tweetActionImage.image = unretweetImage
            tweetActionLabel.text = "\(retweetBy) Retweeted"
        }else if let inReplyto = tweet.inReplyto{
            tweetActionView.hidden = false
            tweetActionImage.image = replyImage
            tweetActionLabel.text = "In reply to @\(inReplyto)"
        }
        else{
            tweetActionView.hidden = true
        }
        
    }
    
    func setTweetText(){
        tweetTextLabel.URLColor = twitterDarkBlue
        tweetTextLabel.hashtagColor = UIColor.blackColor()
        tweetTextLabel.mentionColor = UIColor.blackColor()
        tweetTextLabel.text = tweet.text!
        tweetTextLabel.handleURLTap { (url: NSURL) -> () in
            UIApplication.sharedApplication().openURL(url)
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
    
    func imageTapped(sender: UITapGestureRecognizer){
        print("User Tapped Imaged")
        delegate?.tweetCell?(self, onProfileImageTap: self.tweet)
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
    
    
    @IBAction func onReply(sender: UIButton) {
        print("onReplyClicked")
        delegate?.tweetCell?(self, onTweetReply: self.tweet)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("imageTapped:"))
        //Add the recognizer to your view.
        self.profileImage.addGestureRecognizer(tapRecognizer)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
