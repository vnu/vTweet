//
//  Tweet.swift
//  vTweetz
//
//  Created by Vinu Charanya on 2/18/16.
//  Copyright © 2016 vnu. All rights reserved.
//

import UIKit
import SwiftDate

let twitterBlue = UIColor(red: 0.0/255, green: 172.0/255, blue: 237.0/255, alpha: 1.0)
let twitterDarkBlue = UIColor(red: 0.0/255, green: 132.0/255, blue: 180.0/255, alpha: 1.0)

class Tweet: NSObject {
    
    var tweetId: String?
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var dictionary: NSDictionary
    var tweetedAt: String?
    
    //Retweet
    var retweetCount: Int?
    var retweeted: Bool?
    
    var retweetedBy: String?
    
    //Reply
    
    var inReplyto: String?
    
    //Likes
    var likeCount: Int?
    var liked: Bool?
    
    
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
        super.init()
        if(dictionary["retweeted"] as! Bool){
            let retweetUser = User(dictionary: dictionary["user"] as! NSDictionary)
            retweetedBy = retweetUser.name
            initTweet(dictionary["retweeted_status"] as! NSDictionary)
        }else{
          initTweet(dictionary)
        }
        
    }
    
    func initTweet(dictionary: NSDictionary){
        tweetId = dictionary["id_str"] as? String
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        inReplyto = dictionary["in_reply_to_screen_name"] as? String
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        initTimeAgo()
        initActionItems()
        print(self.dictionary)
    }
    
    func initActionItems(){
        //Likes
        likeCount = dictionary["favorite_count"] as? Int
        liked = dictionary["favorited"] as? Bool
        
        //retweet
        retweetCount = dictionary["retweet_count"] as? Int
        retweeted = dictionary["retweeted"] as? Bool
    }
    
    func initTimeAgo(){
        createdAt = createdAtString!.toDate(DateFormat.Custom("EEE MMM d HH:mm:ss Z y"))
        let style = FormatterStyle(style: .Abbreviated, units: nil, max: 1)
        let region = Region(calendarName: .Current, timeZoneName: .Local, localeName: .Current)
        tweetedAt = createdAt?.toNaturalString(NSDate(), inRegion: region, style: style)
    }
    
    func like(){
        if let liked = self.liked{
            if(liked){
                TwitterAPI.sharedInstance.likeOnTweet(tweetId!, action: "destroy", completion: onLikeRetweetAction)
            }else{
                TwitterAPI.sharedInstance.likeOnTweet(tweetId!, action: "create", completion: onLikeRetweetAction)
            }
        }
    }
    
    func retweet(){
        if let retweeted = self.retweeted{
            if(retweeted){
                TwitterAPI.sharedInstance.postOnTweet("unretweet/\(tweetId!)", completion: onLikeRetweetAction)
            }else{
                TwitterAPI.sharedInstance.postOnTweet("retweet/\(tweetId!)", completion: onLikeRetweetAction)
            }
        }
    }
    
    func onLikeRetweetAction(tweet: Tweet?, error: NSError?){
        if let tweet = tweet{
            self.retweeted = tweet.retweeted
            self.liked = tweet.liked
            self.likeCount = tweet.likeCount
            self.retweetCount = tweet.retweetCount
        }else{
            print("Error on Like/Retweet Action")
        }
    }
    
    //Class Functions
    class func tweetsWithArray(array: [NSDictionary], maxId: String? = nil) -> [Tweet]{
        var tweets = [Tweet]()
        for dictionary in array{
            let tweet = Tweet(dictionary: dictionary)
            if maxId != nil && tweet.tweetId == maxId{
                continue
            }
            tweets.append(tweet)
        }
        return tweets
    }
    
}
