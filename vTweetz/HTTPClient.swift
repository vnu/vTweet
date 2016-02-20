//
//  HTTPClient.swift
//  vTweetz
//
//  Created by Vinu Charanya on 2/18/16.
//  Copyright © 2016 vnu. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class HTTPClient: BDBOAuth1SessionManager{
    
    //API KEYS
    let consumerKey = "Inu8PYBRAuy6eA4H9dPgjkoEX"
    let consumerSecret = "CdDFLjwwJmCYU1bJqfwsVJcj5TlzZdSApGzOBHOB0ssihZLD5w"
    let baseUrlString = "https://api.twitter.com/"
    
    var handleLoginCompletion: ((user: User?, error: NSError?) -> ())?
    
    init(){
        let baseUrl = NSURL(string: baseUrlString)
        super.init(baseURL: baseUrl, consumerKey: consumerKey, consumerSecret: consumerSecret)
    }
    
    override init(baseURL url: NSURL!, sessionConfiguration configuration: NSURLSessionConfiguration!) {
        super.init(baseURL: url, sessionConfiguration: configuration)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loginWithTwitter(completion: (user: User?, error: NSError?) -> Void){
        handleLoginCompletion = completion
        self.requestSerializer.removeAccessToken()
        self.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "vTweetz://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("Got the request token")
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
        }, failure: { (error: NSError!) -> Void in
                self.handleLoginCompletion?(user: nil, error: error)
        })
    }
    
    func fetchAccessToken(urlQuery:String){
        self.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: urlQuery)!, success: { (accessToken:BDBOAuth1Credential!) -> Void in
            print("GOt access token")
            self.requestSerializer.saveAccessToken(accessToken)
            self.fetchUser()
            
        }) { (error:NSError!) -> Void in
            self.handleLoginCompletion?(user: nil, error: error)
        }
    }
    
    func fetchUser(){
        self.GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (session: NSURLSessionDataTask, response:AnyObject?) -> Void in
                let user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                self.handleLoginCompletion?(user: user, error: nil)
            }) { (session: NSURLSessionDataTask?, error:NSError) -> Void in
                self.handleLoginCompletion?(user: nil, error: error)
        }
    }
    
    func fetchHomeTimeline(){
        self.GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (session: NSURLSessionDataTask, response:AnyObject?) -> Void in
//            print(response as! NSArray)
            if let timeline = response as? [NSDictionary]{
                var tweets = Tweet.tweetsWithArray(timeline)
            }
            
            }) { (session: NSURLSessionDataTask?, error:NSError) -> Void in
                print("Error")
        }
    }
    
    func logout(){
        User.currentUser = nil
        self.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }

    
    
    
    
    
}
