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
    
    var handleLogin: ((user: User?, error: NSError?) -> ())?
    
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
    
    func loginWithCompletion(completion: (user: User?, error: NSError?)->()){
        handleLogin = completion
    }
    
    func logout(){
        httpClient.logout()
    }
    
    
    
}