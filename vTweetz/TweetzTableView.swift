//
//  TweetzTable.swift
//  vTweetz
//
//  Created by Vinu Charanya on 2/27/16.
//  Copyright © 2016 vnu. All rights reserved.
//

import UIKit

class TweetzTableView: UITableView{
    
    @IBOutlet weak var tweetzTable: UITableView!
    
    var isMoreDataLoading = false
    var reachedAPILimit = false
    
    let tweetCellId = "com.vnu.tweetcell"
    var fetchEndpoint = "home_timeline.json"
    
    let refreshControl = UIRefreshControl()
    
    //Segues
    let replySegueId = "com.vnu.ReplySegue"
    let homeComposeSegue = "HomeComposeSegue"
    let detailSegueId = "com.vnu.tweetDetail"
    
    let datasource = TweetDataSource()


    
    func initView(fetchEndpoint: String = "home_timeline.json"){
        let cellNib = UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle())
        self.registerNib(cellNib, forCellReuseIdentifier: tweetCellId)
        if (fetchEndpoint.characters.count) > 0 {
            self.fetchEndpoint = fetchEndpoint
        }
        self.estimatedRowHeight = 200
        self.dataSource = datasource
        self.delegate = datasource
        self.rowHeight = UITableViewAutomaticDimension
        
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        self.insertSubview(refreshControl, atIndex: 0)
    }
    
    
    //Fetch Tweets
    func fetchTweets(){
        TwitterAPI.sharedInstance.fetchTweets(fetchEndpoint, completion: onFetchCompletion)
    }
    
    func onFetchCompletion(tweets: [Tweet]?, error: NSError?){
        if tweets != nil{
            self.datasource.tweets = tweets!
            self.reloadData()
        }else{
            print("ERROR OCCURED: \(error?.description)")
        }
        if refreshControl.refreshing{
            refreshControl.endRefreshing()
        }
    }
    
    // Pull to Refresh
    func refreshControlAction(refreshControl: UIRefreshControl) {
        self.fetchTweets()
    }
    
    // Infinite Scrolling
    func loadMoreTweets(){
        print("Loading More tweets")
        let currentTweets = self.datasource.tweets
        if  currentTweets.count > 0{
            let maxTweetId = currentTweets.last?.tweetId!
            TwitterAPI.sharedInstance.loadMoreTweets(fetchEndpoint, maxId: maxTweetId!) { (tweets, error) -> Void in
                if tweets != nil{
                    self.datasource.tweets = currentTweets + tweets!
                    self.reloadData()
                    if(self.isMoreDataLoading){
                        self.isMoreDataLoading = false
                    }
                }else{
                    print("ERROR OCCURED: \(error?.description)")
                }
                
            }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print("Scroll View Did Scroll")
        if (!self.isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            
            let scrollViewContentHeight = self.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - (self.bounds.size.height)
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && self.dragging && !self.reachedAPILimit) {
                self.isMoreDataLoading = true
                self.loadMoreTweets()
            }
            
        }
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
