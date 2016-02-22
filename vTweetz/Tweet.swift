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
    var dictionary: NSDictionary?
    var tweetedAt: String?
    
    //Retweet
    var retweetCount: Int?
    var retweeted: Bool?
    
    var retweetedBy: String?
    
    //Reply
    
    var inReplyto: String?
    var inReplytoTweet: String?
    
    //Likes
    var likeCount: Int?
    var liked: Bool?
    
    var mediaType: String?
    var mediaUrl: String?
    
    
    init(tweet: String){
        super.init()
        user = User.currentUser
        text = tweet
        createdAt = NSDate()
        initTimeAgo()

        
        retweeted = false
        retweetCount = 0
        retweetedBy = nil
        inReplyto = nil
        inReplytoTweet = nil
        
        likeCount = 0
        liked = false
        
    }
    init(responseDictionary: NSDictionary?){
        super.init()
        
        if let dictionary = responseDictionary{
            self.dictionary = dictionary
        if let retweetStatus = dictionary["retweeted_status"] as? NSDictionary{
            let retweetUser = User(dictionary: dictionary["user"] as! NSDictionary)
            retweetedBy = retweetUser.name
            initTweet(retweetStatus)
        }else{
          initTweet(dictionary)
        }
        }
    }
    
    func initTweet(dictionary: NSDictionary){
        tweetId = dictionary["id_str"] as? String
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        inReplyto = dictionary["in_reply_to_screen_name"] as? String
        inReplytoTweet = dictionary["in_reply_to_status_id_str"] as? String
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        createdAt = createdAtString!.toDate(DateFormat.Custom("EEE MMM d HH:mm:ss Z y"))
        initTimeAgo()
        initActionItems()
        initMedia()
//        print(self.dictionary)
    }
    
    func initActionItems(){
        //Likes
        if let dictionary = self.dictionary{
        likeCount = dictionary["favorite_count"] as? Int
        liked = dictionary["favorited"] as? Bool
        
        //retweet
        retweetCount = dictionary["retweet_count"] as? Int
        retweeted = dictionary["retweeted"] as? Bool
        }
    }
    
    func initTimeAgo(){
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
    
    
    func initMedia(){
        if dictionary != nil  && dictionary!["entities"] != nil {
            
            let entitiesDict = dictionary!["entities"] as! NSDictionary
            if entitiesDict["media"] != nil {
                let medias = entitiesDict["media"] as! NSArray
                let media = medias[0] as! NSDictionary
                self.mediaUrl = media["media_url"] as? String
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
            let tweet = Tweet(responseDictionary: dictionary)
            if maxId != nil && tweet.tweetId == maxId{
                continue
            }
            tweets.append(tweet)
        }
        return tweets
    }
    
}
