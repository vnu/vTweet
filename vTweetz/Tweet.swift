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
    
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var dictionary: NSDictionary
    var tweetedAt: String?
    
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
        super.init()
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        setTimeAgo()
    }
    
    func setTimeAgo(){
        createdAt = createdAtString!.toDate(DateFormat.Custom("EEE MMM d HH:mm:ss Z y"))
        let style = FormatterStyle(style: .Abbreviated, units: nil, max: 1)
        let region = Region(calendarName: .Current, timeZoneName: .Local, localeName: .Current)
        tweetedAt = createdAt?.toNaturalString(NSDate(), inRegion: region, style: style)
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
