//
//  TwitterAPIClient.swift
//  vTweetz
//
//  Created by Vinu Charanya on 2/18/16.
//  Copyright © 2016 vnu. All rights reserved.
//

import UIKit

class TwitterAPI{
    
    static let sharedInstance = TwitterAPI()
    
    private let httpClient: HTTPClient
    private let isOnline: Bool
    private let persistenceManager: PersistenceManager
    
    init(){
        httpClient = HTTPClient()
        isOnline = false
        persistenceManager = PersistenceManager()
    }
    
    func loginWithTwitter(completion: (user: User?, error: NSError?) -> Void){
        httpClient.loginWithTwitter(completion)
    }
    
    func saveAccessToken(urlQuery: String){
        httpClient.fetchAccessToken(urlQuery)
    }
    
    func fetchUserInfo(){
        httpClient.fetchUser()
    }
    
    func logout(){
        httpClient.logout()
    }
    
    func fetchTweets(fetchString: String, completion: (tweets: [Tweet]?, error: NSError?)->()){
       httpClient.fetchTweets(fetchString, completion: completion)
    }
    
    func likeOnTweet(tweetId: String, action: String, completion: (tweet: Tweet?, error: NSError?) -> Void){
        httpClient.likeOnTweet(tweetId, action: action, completion: completion)
    }
    
    func postOnTweet(postUrl: String, completion: (tweet: Tweet?, error: NSError?) -> Void){
        httpClient.postOnTweet(postUrl, completion: completion)
    }
    
    
    
}