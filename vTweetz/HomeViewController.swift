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
    
    let tweetCellId = "com.vnu.tweetcell"
    let tweetStatus = "home_timeline"
    
    private var tweets = [Tweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle())
        tweetsTableView.registerNib(cellNib, forCellReuseIdentifier: tweetCellId)

        tweetsTableView.estimatedRowHeight = 200
        tweetsTableView.rowHeight = UITableViewAutomaticDimension

        fetchTweets()
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
            print("ERROR OCCURED: \(error)")
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
}
