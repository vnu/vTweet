//
//  Tweet.swift
//  vTweetz
//
//  Created by Vinu Charanya on 2/18/16.
//  Copyright © 2016 vnu. All rights reserved.
//

import UIKit
import SwiftDate

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
    
    //Reply
    
    //Likes
    var likeCount: Int?
    var liked: Bool?
    
    
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
        super.init()
        tweetId = dictionary["id_str"] as? String
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        initTimeAgo()
        initActionItems()
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
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        for dictionary in array{
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
    
}
