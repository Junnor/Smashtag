//
//  TweetImageTableViewCell.swift
//  Smashtag
//
//  Created by Junor on 16/3/18.
//  Copyright © 2016年 Junor. All rights reserved.
//

import UIKit

class TweetImageTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetProfileImageView: UIImageView! {
        didSet {
            tweetProfileImageView.sizeToFit()
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
}
