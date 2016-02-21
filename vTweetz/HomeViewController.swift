//
//  HomeViewController.swift
//  vTweetz
//
//  Created by Vinu Charanya on 2/19/16.
//  Copyright © 2016 vnu. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {


    @IBOutlet weak var tweetsTableView: UITableView!
    
    var isMoreDataLoading = false
    var reachedAPILimit = false
    
    let tweetCellId = "com.vnu.tweetcell"
    let tweetStatus = "home_timeline.json"
    let detailSegueId = "com.vnu.tweetDetail"
    let refreshControl = UIRefreshControl()
    
    private var tweets = [Tweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle())
        tweetsTableView.registerNib(cellNib, forCellReuseIdentifier: tweetCellId)

        tweetsTableView.estimatedRowHeight = 200
        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        setTweetyNavBar()
        fetchTweets()

        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tweetsTableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    func setTweetyNavBar(){
        let logo = UIImage(named: "Twitter_logo_blue_32")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
    }
    
    
    @IBAction func onLogout(sender: UIBarButtonItem) {
        User.currentUser?.logout()
    }
    
    //Fetch Tweets
    func fetchTweets(){
        TwitterAPI.sharedInstance.fetchTweets(tweetStatus, completion: onFetchCompletion)
    }
    
    func onFetchCompletion(tweets: [Tweet]?, error: NSError?){
        if tweets != nil{
            self.tweets = tweets!
            tweetsTableView.reloadData()
        }else{
            print("ERROR OCCURED: \(error?.description)")
        }
        if refreshControl.refreshing{
            refreshControl.endRefreshing()
        }
        
    }
    
    //Segue into Detail View
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == detailSegueId {
            if let destination = segue.destinationViewController as? TweetViewController {
                if let cell = sender as? TweetCell{
                    let indexPath = self.tweetsTableView!.indexPathForCell(cell)
                    let index = indexPath!.row
                    destination.tweet = tweets[index]
                }
                destination.hidesBottomBarWhenPushed = true
            }
        }
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        self.fetchTweets()
    }
    
    func loadMoreTweets(){
        print("Came here to load more tweets")
        if tweets.count > 0{
        let maxTweetId = tweets.last?.tweetId!
        TwitterAPI.sharedInstance.loadMoreTweets(tweetStatus, maxId: maxTweetId!) { (tweets, error) -> Void in
            if tweets != nil{
                self.tweets = self.tweets + tweets!
                self.tweetsTableView.reloadData()
                if(self.isMoreDataLoading){
                    self.isMoreDataLoading = false
                }
                print(self.tweets.count)
            }else{
                print("ERROR OCCURED: \(error?.description)")
            }
            
        }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension HomeViewController:UIScrollViewDelegate{
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results

            let scrollViewContentHeight = tweetsTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - (tweetsTableView.bounds.size.height)
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tweetsTableView.dragging && !reachedAPILimit) {
                isMoreDataLoading = true
                loadMoreTweets()
            }

        }
    }
}

extension HomeViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(tweetCellId) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as!TweetCell
        self.performSegueWithIdentifier(detailSegueId, sender: selectedCell)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
