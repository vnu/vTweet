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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.setImageWithURL(NSURL(string: (User.currentUser?.profileImageUrl)!)!)
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        nameLabel.morphingEffect = .Sparkle
        nameLabel.text = User.currentUser?.name
        screenNameLabel.morphingEffect = .Fall
        screenNameLabel.text = User.currentUser?.screenName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(sender: AnyObject) {
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
