//
//  ComposeViewController.swift
//  vTweetz
//
//  Created by Vinu Charanya on 2/21/16.
//  Copyright © 2016 vnu. All rights reserved.
//

import UIKit
import LTMorphingLabel


class ComposeViewController: UIViewController {
    @IBOutlet weak var nameLabel: LTMorphingLabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var screenNameLabel: LTMorphingLabel!
    @IBOutlet weak var tweetText: UITextView!
    
    var fromTweet: Tweet?
    var toScreenNames = [String]()
    var toolbar: UIToolbar!
    var tweetCount: UIBarButtonItem!
    var tweetButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.setImageWithURL(NSURL(string: (User.currentUser?.profileImageUrl)!)!)
        tweetText.delegate = self
        if toScreenNames.count > 0{
            var replyToNames = ""
            for screenName in toScreenNames{
                replyToNames += screenName
            }
            tweetText.text = "\(replyToNames) "
        }
        self.tweetText.inputAccessoryView = twitterKeyboard()
    }
    
    func twitterKeyboard() -> UIToolbar{
        self.toolbar = UIToolbar()
//        let camera = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: Selector("btnOpenCamera"))
        let spaceBarItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        tweetButton = UIBarButtonItem(title: "Tweet", style: UIBarButtonItemStyle.Plain, target: self, action: "onTweet:")
        tweetButton.title = "Tweet"
        tweetButton.tintColor = twitterBlue
        tweetCount = UIBarButtonItem()
        tweetCount.title = "\(140 - tweetText.text.characters.count)"
        tweetCount.tintColor = twitterBlue
        toolbar.sizeToFit()
        toolbar.items = [tweetCount, spaceBarItem,tweetButton]
        return toolbar
    }
    
    func onTweet(controller: ComposeViewController){
        print("TweetClicked: \(self.tweetText.text)")
    }
    
    override func viewDidAppear(animated: Bool) {
        nameLabel.morphingEffect = .Sparkle
        nameLabel.text = User.currentUser?.name
        screenNameLabel.morphingEffect = .Fall
        screenNameLabel.text = "@\(User.currentUser?.screenName)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
   
}

extension ComposeViewController:UITextViewDelegate{
    func textViewDidChange(textView: UITextView) {
        let textCount = 140 - textView.text.characters.count
        if(textCount < 0){
         tweetCount.tintColor = UIColor.redColor()
         tweetButton.tintColor = UIColor.grayColor()
         tweetButton.enabled = false
        }else{
            tweetCount.tintColor = twitterBlue
            tweetButton.tintColor = twitterBlue
            tweetButton.enabled = true
        }
        self.tweetCount.title = "\(textCount)"
    }
}
