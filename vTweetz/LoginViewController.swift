//
//  ViewController.swift
//  vTweetz
//
//  Created by Vinu Charanya on 2/18/16.
//  Copyright © 2016 vnu. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    
    var user: User?


    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func onLogin(sender: UIButton) {
        TwitterAPI.sharedInstance.loginWithTwitter(onLoginCompletion)
    }
    
    func onLoginCompletion(user: User?, error: NSError?){
        if user != nil{
            self.performSegueWithIdentifier("com.vnu.loginSegue", sender: self)
        }else{
            print("ERROR OCCURED: \(error)")
            handleloginFailure()
        }
    }
    
    func handleloginFailure(){
        //handle error message here
        
    }
    


}

