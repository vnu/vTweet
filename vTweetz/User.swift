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
    
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagLine = dictionary["description"] as? String
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
