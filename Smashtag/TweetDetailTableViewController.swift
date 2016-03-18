
//
//  TweetDetailTableViewController.swift
//  Smashtag
//
//  Created by Junor on 16/3/18.
//  Copyright © 2016年 Junor. All rights reserved.
//

import UIKit

class TweetDetailTableViewController: UITableViewController {
    
    var mediaUrls = [String]()
    var urls = [String]()
    var hashtags = [String]()
    var userMentions = [String]()
    
    var imageAspectRatio: Double = 1.0   //   width / height
    
    var unwindTappedString: String = ""
    
    private var resutls = [[String]]()
    private var image: UIImage?
    
    // MARK: - ViewControllr Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resutls.append(mediaUrls)
        resutls.append(urls)
        resutls.append(hashtags)
        resutls.append(userMentions)
        
//        print("results = \(resutls)")
    }
    
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("prepareForSegue()")
        
        if segue.identifier == "ShowImage" {
            if let imageVc = segue.destinationViewController as? TweetImageViewController {
                imageVc.image = image
                print("In tweet's image aspect ratio = \(image!.size.width / image!.size.height)")
            }
        } else {
            if let cell = sender as? UITableViewCell {
                if let indexPath = tableView.indexPathForCell(cell) {
                    if indexPath.section != 1 {
                        unwindTappedString = resutls[indexPath.section][indexPath.row]
                    }
                }
            }
        }
    }
    
    // MARK: - TableView DataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return resutls.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resutls[section].count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("TweetImage") as! TweetImageTableViewCell
            if resutls[indexPath.section].count != 0 {
                cell.spinner?.startAnimating()
            }
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) { () -> Void in
                let imageUrl = NSURL(string: self.mediaUrls[0])
                let imageData = NSData(contentsOfURL: imageUrl!)
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.image = UIImage(data: imageData!)
                    cell.tweetProfileImageView.image = self.image
                    cell.spinner?.stopAnimating()
                }
            }
            return cell
        } else {
            let identifier = indexPath.section == 1 ? "TweetUrl" : "TweetDetail"
            let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = resutls[indexPath.section][indexPath.row]
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0: return resutls[0].count != 0 ? "Images" : nil
        case 1: return resutls[1].count != 0 ? "Urls" : nil
        case 2: return resutls[2].count != 0 ? "Hashtags" : nil
        case 3: return resutls[3].count != 0 ? "Users" : nil
        default: return nil
        }
    }
    
    
    // MARK: - TableView Delegate

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return self.view.bounds.size.width / CGFloat(imageAspectRatio)
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // The order of performance 
        // prepareForSegue() -> unwindForSegue() ->  didSelectRowAtIndexPath()
        print("didSelectRowAtIndexPath()")
        if indexPath.section == 1 {
            let url = NSURL(string: urls[0])
            UIApplication.sharedApplication().openURL(url!)
        }
    }
    
}
