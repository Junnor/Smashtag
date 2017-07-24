
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
    
    fileprivate var resutls = [[String]]()
    fileprivate var image: UIImage?
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepareForSegue()")
        
        if segue.identifier == "ShowImage" {
            if let imageVc = segue.destination as? TweetImageViewController {
                imageVc.image = image
                print("In tweet's image aspect ratio = \(image!.size.width / image!.size.height)")
            }
        } else {
            if let cell = sender as? UITableViewCell {
                if let indexPath = tableView.indexPath(for: cell) {
                    if indexPath.section != 1 {
                        unwindTappedString = resutls[indexPath.section][indexPath.row]
                    }
                }
            }
        }
    }
    
    // MARK: - TableView DataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return resutls.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resutls[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TweetImage") as! TweetImageTableViewCell
            if resutls[indexPath.section].count != 0 {
                cell.spinner?.startAnimating()
            }
            
            DispatchQueue.global().async {
                let imageUrl = URL(string: self.mediaUrls[0])
                let imageData = try? Data(contentsOf: imageUrl!)
                DispatchQueue.main.async { () -> Void in
                    self.image = UIImage(data: imageData!)
                    cell.tweetProfileImageView.image = self.image
                    cell.spinner?.stopAnimating()
                }

            }
            
            return cell
        } else {
            let identifier = indexPath.section == 1 ? "TweetUrl" : "TweetDetail"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as UITableViewCell
            cell.textLabel?.text = resutls[indexPath.section][indexPath.row]
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0: return resutls[0].count != 0 ? "Images" : nil
        case 1: return resutls[1].count != 0 ? "Urls" : nil
        case 2: return resutls[2].count != 0 ? "Hashtags" : nil
        case 3: return resutls[3].count != 0 ? "Users" : nil
        default: return nil
        }
    }
    
    
    // MARK: - TableView Delegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return self.view.bounds.size.width / CGFloat(imageAspectRatio)
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // The order of performance 
        // prepareForSegue() -> unwindForSegue() ->  didSelectRowAtIndexPath()
        print("didSelectRowAtIndexPath()")
        if indexPath.section == 1 {
            let url = URL(string: urls[0])
            UIApplication.shared.openURL(url!)
        }
    }
    
}
