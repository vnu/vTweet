//
//  TweetDataSource.swift
//  vTweetz
//
//  Created by Vinu Charanya on 2/27/16.
//  Copyright © 2016 vnu. All rights reserved.
//

import UIKit

class TweetDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    //CELL Identifiers
    let tweetCellId = "com.vnu.tweetcell"
    
    //Model Vars
    var user: User!
    var tweets = [Tweet]()
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(tweetCellId) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        //        cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    
}
