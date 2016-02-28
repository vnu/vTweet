//
//  TweetzCell.swift
//  vTweetz
//
//  Created by Vinu Charanya on 2/27/16.
//  Copyright © 2016 vnu. All rights reserved.
//

import UIKit
import ActiveLabel

class TweetView: UIView {
    
        
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetedAtLabel: UILabel!
    @IBOutlet weak var tweetActionImage: UIImageView!
    @IBOutlet weak var tweetActionLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: ActiveLabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    
    @IBOutlet weak var tweetActionView: UIStackView!
    
    
    @IBOutlet weak var mediaImage: UIImageView!
    @IBOutlet weak var imageMediaHeightConstraint: NSLayoutConstraint!
    

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
