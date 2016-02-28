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
    var tableCellDelegate: TweetCellDelegate?
    
    //Segues
    let replySegueId = "com.vnu.ReplySegue"
    let homeComposeSegue = "HomeComposeSegue"
    let detailSegueId = "com.vnu.tweetDetail"
    
    let datasource = TweetDataSource()
    
    func setCellDelegate(delegate: TweetCellDelegate?){
        datasource.cellDelegate = delegate
    }
    
    func initView(fetchEndpoint: String = "home_timeline.json"){
        let cellNib = UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle())
        self.registerNib(cellNib, forCellReuseIdentifier: tweetCellId)
        if (fetchEndpoint.characters.count) > 0 {
            self.fetchEndpoint = fetchEndpoint
        }
        self.estimatedRowHeight = 200
        self.dataSource = datasource
        self.rowHeight = UITableViewAutomaticDimension
        
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        self.insertSubview(refreshControl, atIndex: 0)
    }
    
    
    //Fetch Tweets
    func fetchTweets(parameters: NSDictionary = NSDictionary()){
        TwitterAPI.sharedInstance.fetchTweets(fetchEndpoint, parameters: parameters, completion: onFetchCompletion)
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
    func loadMoreTweets(var parameters: Dictionary<String, String>){
        print("Loading More tweets")
        let currentTweets = self.datasource.tweets
        if  currentTweets.count > 0{
            let maxTweetId = currentTweets.last?.tweetId!
            parameters["max_id"] = maxTweetId!

            TwitterAPI.sharedInstance.loadMoreTweets(fetchEndpoint, parameters: parameters) { (tweets, error) -> Void in
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
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
