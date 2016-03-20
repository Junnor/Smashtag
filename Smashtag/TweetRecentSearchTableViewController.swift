//
//  TweetRecentSearchTableViewController.swift
//  Smashtag
//
//  Created by Junor on 16/3/19.
//  Copyright © 2016年 Junor. All rights reserved.
//

import UIKit

class TweetRecentSearchTableViewController: UITableViewController {
    
    var recentSearchText: String = "" {
        didSet {
            if !recentSearchResults.contains(recentSearchText) {
                if recentSearchResults.count >= 100 {
                    recentSearchResults.removeFirst()
                }
                recentSearchResults.append(recentSearchText)
            }
        }
    }
    
    private let ResultsKey = "ResultsKey"
    private let defaults = NSUserDefaults.standardUserDefaults()
    private var recentSearchResults: [String] {
        get {
            return defaults.objectForKey(ResultsKey) as? [String] ?? ["#stanford"]
        }
        set {
            defaults.setObject(newValue, forKey: ResultsKey)
            print("results = \(newValue)")
        }
    }
    
    
    // MARK: - ViewController Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - TableView DataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearchResults.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Recent Search", forIndexPath: indexPath)
        cell.textLabel?.text = recentSearchResults[indexPath.row]

        return cell
    }
    
    // MARK: - TableView Delegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedData = recentSearchResults[indexPath.row]
        
        var destination = self.tabBarController?.viewControllers![0]
        if let naVC = destination as? UINavigationController {
            destination = naVC.visibleViewController
        }
        
        if let tweetVC = destination as? TweetTableViewController {
            tweetVC.searchText = selectedData
        }
        
    }

}
