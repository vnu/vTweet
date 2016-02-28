//
//  User.swift
//  vTweetz
//
//  Created by Vinu Charanya on 2/18/16.
//  Copyright © 2016 vnu. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    
    var name: String?
    var screenName: String?
    var profileImageUrl: String?
    var tagLine: String?
    var dictionary: NSDictionary
    var following: Int?
    var followersCount: Int?
    var friendsCount: Int?
    var userId: String?
    var profileBgColor: String?
    var profileBgImageUrl: String?
    var verified: Bool?
    var location: String?
    var displayUrl: String?
    var expandedUrl: String?
    
    
    
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagLine = dictionary["description"] as? String
        following = dictionary["following"] as? Int
        followersCount = dictionary["followers_count"] as? Int
        friendsCount = dictionary["friends_count"] as? Int
        userId = dictionary["id_str"] as? String
        profileBgColor = dictionary["profile_background_color"] as? String
        profileBgImageUrl = dictionary["profile_background_image_url"] as? String
        verified = dictionary["verified"] as? Bool
        location = dictionary["location"] as? String
        
        //Set entity Urls
        if let entities = dictionary["entities"] as? NSDictionary{
            if let url = entities["url"] as? NSDictionary{
                if let entityUrls = url["urls"] as? NSArray{
                    if let entity = entityUrls[0] as? NSDictionary{
                        displayUrl = entity["display_url"] as? String
                        expandedUrl = entity["expanded_url"] as? String
                    }
                }
            }
        }
        print(dictionary)
    }
    
    func logout(){
        TwitterAPI.sharedInstance.logout()
    }
    
    class var currentUser: User? {
        get{
            if _currentUser == nil{
        
                let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if let userData = data {
                    do{
                        let dictionary = try NSJSONSerialization.JSONObjectWithData(userData, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                        _currentUser = User(dictionary: dictionary!)
                    }catch let error as NSError{
                        _currentUser = nil
                        print("JSON Parsing in userdefaults threw an error: \(error)")
                    }
                }
        
            }
            return _currentUser
        }
        
        
        set(user){
            _currentUser = user
                if _currentUser != nil {
                    do{
                        let data = try NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: NSJSONWritingOptions.PrettyPrinted)
                        NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                    }catch let error as NSError{
                        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
                        print("JSON Parsing in userdefaults threw an error: \(error)")
                    }
                    
                }else{
                    NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
                }
                NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    
}
