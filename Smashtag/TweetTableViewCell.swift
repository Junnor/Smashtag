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
    
    fileprivate func updateUI() {
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
                    mutaAttStr.addAttributes([NSForegroundColorAttributeName: UIColor.blue], range: hashtag.nsrange)
                }
                for url in tweet.urls {
                    mutaAttStr.addAttributes([NSForegroundColorAttributeName: UIColor.blue], range: url.nsrange)
                }
                for mentionUser in tweet.userMentions {
                    mutaAttStr.addAttributes([NSForegroundColorAttributeName: UIColor.blue], range: mentionUser.nsrange)

                }
                
                tweetTextLabel.attributedText = mutaAttStr
            }
            

            tweetScreenNameLabel?.text = "\(tweet.user)"
            
            if let profileImageURL = tweet.user.profileImageURL {
                
                DispatchQueue.global().sync {
                    if let imageeData = try? Data(contentsOf: profileImageURL) { // Block main thread
                        DispatchQueue.main.async { () -> Void in
                            self.tweetProfileImageView?.image = UIImage(data: imageeData)
                        }
                    }

                }
            }
        }
        
    }
    
}
