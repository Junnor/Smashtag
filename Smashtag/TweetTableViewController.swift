//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by Junor on 16/3/16.
//  Copyright © 2016年 Junor. All rights reserved.
//

import UIKit

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    
    var searchText: String? = "#stanford" {
        didSet {
            lastSuccessfulRequst = nil
            searchTextField?.text = searchText
            tweets.removeAll()
            tableView.reloadData()
            refresh()
            
            if searchText != nil {
                let recentSearchVC = TweetRecentSearchTableViewController()
                recentSearchVC.recentSearchText = searchText!
            }
        }
    }
    
    private var tweets = [[Tweet]]()
    
    // MARK: - View Controller lifecycel

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        refresh()
    }
    
    // get more data
    private var lastSuccessfulRequst: TwitterRequest?
    private var nextRequestToAttempt: TwitterRequest? {
        if lastSuccessfulRequst == nil {
            if searchText != nil {
                return TwitterRequest(search: searchText!, count: 100)
            } else {
                return nil
            }
        } else {
            return lastSuccessfulRequst!.requestForNewer
        }
    }
    
    private func refresh() {
        if refreshControl != nil {
            refreshControl?.beginRefreshing()
        }
        
        refresh(refreshControl)
    }
    
    
    @IBAction func refresh(sender: UIRefreshControl?) {
        if searchText != nil {
            if let request = nextRequestToAttempt {
                let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
                dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
                    request.fetchTweets { (newTweets) -> Void in
                        dispatch_async(dispatch_get_main_queue()) { () -> Void in
                            if newTweets.count > 0 {
                                self.tweets.insert(newTweets, atIndex: 0)
                                self.tableView.reloadData()
                                sender?.endRefreshing()
                            }
                        }
                    }
                }
            }
        } else {
            sender?.endRefreshing()
        }
    }

    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == searchTextField {
            textField.resignFirstResponder()
            searchText = textField.text
        }
        
        return true
    }

    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let tweetDTV = segue.destinationViewController as? TweetDetailTableViewController
        if let identifier = segue.identifier {
            if identifier == "ShowTweetDetail" {
                if let tweetCell = sender as? TweetTableViewCell {
                    let selectedTweet = tweetCell.tweet!
                    
                    var mediaUrls = [String]()
                    for media in selectedTweet.media {
                        mediaUrls.append(media.url.absoluteString)
                        tweetDTV?.imageAspectRatio = media.aspectRatio
                    }
                    
                    tweetDTV?.mediaUrls = mediaUrls
                    tweetDTV?.urls = stringsForTweetInfos(selectedTweet.urls)
                    tweetDTV?.userMentions = stringsForTweetInfos(selectedTweet.userMentions)
                    tweetDTV?.hashtags = stringsForTweetInfos(selectedTweet.hashtags)
                    
                }
            }
            tweetDTV?.title = "Tweet Detail"
            
        }
    }
    
    @IBAction override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("unwindForSegue()")
        if unwindSegue.identifier == "TweetDetailComeBack" {
            if let backVC = unwindSegue.sourceViewController as? TweetDetailTableViewController {
                searchText = backVC.unwindTappedString
            }
        }
    }
    
    func stringsForTweetInfos(keys: [Tweet.IndexedKeyword]) -> [String] {
        var strings = [String]()
        for key in keys {
            strings.append(key.keyword)
        }
        return strings
    }

    // MARK: - TableView DataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tweets.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Tweet", forIndexPath: indexPath) as!  TweetTableViewCell

        // Configure the cell...
        cell.tweet = tweets[indexPath.section][indexPath.row]
        
        return cell
    }

}
