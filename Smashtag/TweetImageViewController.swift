//
//  TweetImageViewController.swift
//  Smashtag
//
//  Created by Junor on 16/3/18.
//  Copyright © 2016年 Junor. All rights reserved.
//

import UIKit

class TweetImageViewController: UIViewController {
    
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            imageView.frame = getImageViewsFrameFromImage(newValue)
            scrollView?.contentSize = imageView.bounds.size
        }
    }
    
    private var imageView = UIImageView()
    private func getImageViewsFrameFromImage(image: UIImage?) -> CGRect {
        if image != nil {
            let viewAspectRatio = self.view.bounds.size.width / self.view.bounds.size.height
            let imageAspectRatio = (image?.size.width)! / (image?.size.height)!
            var addition: CGFloat = 0.0
            var imageWidth: CGFloat = 0.0
            var imageHeight: CGFloat = 0.0
            if viewAspectRatio > imageAspectRatio {  // change width to satisfy the  aspect ratio
                addition = self.view.bounds.size.width - (image?.size.width)!
                imageWidth = self.view.bounds.size.width
                imageHeight = ((image?.size.height)! * addition / (image?.size.width)!) + (image?.size.height)!
                
            } else { // change height to satisfy the aspect ratio
                addition = self.view.bounds.size.height - (image?.size.height)!
                imageWidth = ((image?.size.width)! * addition / (image?.size.height)!) + (image?.size.width)!
                imageHeight =  self.view.bounds.size.height
            }
            print("In imageView's aspect ratio = \(imageWidth / imageHeight)")
            return  CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        } else {
            return CGRectZero
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.5
            scrollView.maximumZoomScale = 2.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
    }
    
}

extension TweetImageViewController: UIScrollViewDelegate {
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}
