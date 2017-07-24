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
    
    fileprivate let ResultsKey = "ResultsKey"
    fileprivate let defaults = UserDefaults.standard
    fileprivate var recentSearchResults: [String] {
        get {
            return defaults.object(forKey: ResultsKey) as? [String] ?? ["#stanford"]
        }
        set {
            defaults.set(newValue, forKey: ResultsKey)
            print("results = \(newValue)")
        }
    }
    
    
    // MARK: - ViewController Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - TableView DataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearchResults.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Recent Search", for: indexPath)
        cell.textLabel?.text = recentSearchResults[indexPath.row]

        return cell
    }
    
    // MARK: - TableView Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
