//
//  ViewPhotoViewController.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 14/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import UIKit

class ViewPhotoViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    var imageView: UIImageView!

    var ImageUrl:String?

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        // 1
        let image = UIImage(named: "CoordinatorVCBackground")!
        imageView = UIImageView(image: image)
        imageView.frame = CGRect(origin: CGPointMake(0.0, 0.0), size:image.size)

        // 2
        scrollView.addSubview(imageView)
        scrollView.contentSize = image.size

        // 3
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "scrollViewDoubleTapped:")
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(doubleTapRecognizer)

        // 4
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleWidth, scaleHeight);
        scrollView.minimumZoomScale = minScale;

        // 5
        scrollView.maximumZoomScale = 3.0
        scrollView.zoomScale = minScale;

        // 6
        centerScrollViewContents()
    }

    @IBAction func DoneButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func centerScrollViewContents() {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = imageView.frame

        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }

        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }

        imageView.frame = contentsFrame

    }

    func scrollViewDoubleTapped(recognizer: UITapGestureRecognizer) {
        // 1
        let pointInView = recognizer.locationInView(imageView)

        // 2
        var newZoomScale = scrollView.zoomScale * 1.5
        newZoomScale = min(newZoomScale, scrollView.maximumZoomScale)

        // 3
        let scrollViewSize = scrollView.bounds.size
        let w = scrollViewSize.width / newZoomScale
        let h = scrollViewSize.height / newZoomScale
        let x = pointInView.x - (w / 2.0)
        let y = pointInView.y - (h / 2.0)

        let rectToZoomTo = CGRectMake(x, y, w, h);

        // 4
        scrollView.zoomToRect(rectToZoomTo, animated: true)
    }

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(scrollView: UIScrollView) {
        centerScrollViewContents()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
}
