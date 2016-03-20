//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Junor on 16/3/16.
//  Copyright © 2016年 Junor. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    private func updateUI() {
        tweetProfileImageView.image = nil
        tweetScreenNameLabel.text = nil
        tweetTextLabel.attributedText = nil
        
        if let tweet = self.tweet {
            tweetTextLabel?.text = tweet.text
            if tweetTextLabel.text != nil {
                
                for _ in tweet.media {
                    tweetTextLabel.text! += " 📷"
                }
                
                let mutaAttStr: NSMutableAttributedString = tweetTextLabel.attributedText as! NSMutableAttributedString
                
                // highlight the hashtag, url and mention user
                for hashtag in tweet.hashtags {
                    mutaAttStr.addAttributes([NSForegroundColorAttributeName: UIColor.blueColor()], range: hashtag.nsrange)
                }
                for url in tweet.urls {
                    mutaAttStr.addAttributes([NSForegroundColorAttributeName: UIColor.blueColor()], range: url.nsrange)
                }
                for mentionUser in tweet.userMentions {
                    mutaAttStr.addAttributes([NSForegroundColorAttributeName: UIColor.blueColor()], range: mentionUser.nsrange)

                }
                
                tweetTextLabel.attributedText = mutaAttStr
            }
            

            tweetScreenNameLabel?.text = "\(tweet.user)"
            
            if let profileImageURL = tweet.user.profileImageURL {
                dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) { () -> Void in
                    if let imageeData = NSData(contentsOfURL: profileImageURL) { // Block main thread
                        dispatch_async(dispatch_get_main_queue()) { () -> Void in
                            self.tweetProfileImageView?.image = UIImage(data: imageeData)
                        }
                    }
                }
            }
        }
        
    }
    
}
