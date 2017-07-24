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
    
    fileprivate var tweets = [[Tweet]]()
    
    // MARK: - View Controller lifecycel

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        refresh()
    }
    
    // get more data
    fileprivate var lastSuccessfulRequst: Request?
    fileprivate var nextRequestToAttempt: Request? {
        if lastSuccessfulRequst == nil {
            if searchText != nil {
                return Request(search: searchText!, count: 100)
            } else {
                return nil
            }
        } else {
            return lastSuccessfulRequst!.newer
        }
    }
    
    fileprivate func refresh() {
        if refreshControl != nil {
            refreshControl?.beginRefreshing()
        }
        
        refresh(refreshControl)
    }
    
    
    @IBAction func refresh(_ sender: UIRefreshControl?) {
        if searchText != nil {
            if let request = nextRequestToAttempt {
                DispatchQueue.global().async {
                    request.fetchTweets { (newTweets) -> Void in
                        DispatchQueue.main.async { () -> Void in
                            if newTweets.count > 0 {
                                self.tweets.insert(newTweets, at: 0)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            textField.resignFirstResponder()
            searchText = textField.text
        }
        
        return true
    }

    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tweetDTV = segue.destination as? TweetDetailTableViewController
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
    
    @IBAction override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("unwindForSegue()")
        if unwindSegue.identifier == "TweetDetailComeBack" {
            if let backVC = unwindSegue.source as? TweetDetailTableViewController {
                searchText = backVC.unwindTappedString
            }
        }
    }
    
    func stringsForTweetInfos(_ keys: [Mention]) -> [String] {
        var strings = [String]()
        for key in keys {
            strings.append(key.keyword)
        }
        return strings
    }

    // MARK: - TableView DataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tweet", for: indexPath) as!  TweetTableViewCell

        // Configure the cell...
        cell.tweet = tweets[indexPath.section][indexPath.row]
        
        return cell
    }

}
