//
//  TweetViewController.swift
//  vTweetz
//
//  Created by Vinu Charanya on 2/20/16.
//  Copyright © 2016 vnu. All rights reserved.
//

import UIKit
import ActiveLabel

class TweetViewController: UIViewController {
    
    var tweet: Tweet!
    
    
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
    let retweetImage = UIImage(named: "retweet-action-on")
    let unretweetImage = UIImage(named: "retweet-action")
    let likeImage = UIImage(named: "like-action-on")
    let unlikeImage = UIImage(named: "like-action")
    
    let detailComposeSegueId = "tweetDetailComposeSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTweet()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTweetAction(){
        if let retweetBy = tweet.retweetedBy{
            tweetActionView.hidden = false
            tweetActionImage.image = unretweetImage
            tweetActionLabel.text = "\(retweetBy) Retweeted"
        }else if let inReplyto = tweet.inReplyto{
            tweetActionView.hidden = false
            tweetActionLabel.text = "In reply to @\(inReplyto)"
        }
        else{
            tweetActionView.hidden = true
        }
        
    }
    
    func setUpTweet(){
        if let tweet = self.tweet{
        nameLabel.text = tweet.user!.name!
        screenNameLabel.text = "@\(tweet.user!.screenName!)"
        tweetedAtLabel.text = tweet.tweetedAt!
        retweetLabel.text = "\(tweet.retweetCount!)"
        likeLabel.text = "\(tweet.likeCount!)"
        profileImage.setImageWithURL(NSURL(string: (tweet.user?.profileImageUrl)!)!)
        setTweetText()
        setLikeImage(!tweet.liked!)
        setRetweetImage(!tweet.retweeted!)
        setTweetAction()
        }
    }
    
    func setTweetText(){
        tweetTextLabel.URLColor = twitterDarkBlue
        tweetTextLabel.hashtagColor = twitterDarkBlue
        tweetTextLabel.mentionColor = twitterDarkBlue
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
    
    
    @IBAction func onReply(sender: AnyObject) {
        self.performSegueWithIdentifier(self.detailComposeSegueId, sender: self)
    }
    
    //Segue into Detail View
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == detailComposeSegueId {
            if let destination = segue.destinationViewController as? ComposeViewController {
                destination.fromTweet = self.tweet
                destination.toScreenNames = ["@\(self.tweet.user!.screenName!)"]
                destination.hidesBottomBarWhenPushed = true
            }
        }
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
