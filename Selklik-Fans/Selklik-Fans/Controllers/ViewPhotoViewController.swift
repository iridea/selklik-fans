//
//  ViewPhotoViewController.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 14/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage




class ViewPhotoViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    var imageView: UIImageView!

    var ImageUrl:String!

    let photoInfo = Photo()

    func downloadImage()->UIImage{

        var downloadedImage:UIImage?
        print("ImageUrl:\(ImageUrl)")
        Alamofire.request(.GET, ImageUrl)
            .responseImage { response in
                debugPrint(response)

                print(response.request)
                print(response.response)
                debugPrint(response.result)

                if let image = response.result.value {
                    print("image downloaded: \(image)")
                    downloadedImage = image
                }
        }

        return downloadedImage!
    }

    override func viewDidAppear(animated: Bool) {
        navigationController?.hidesBarsOnSwipe = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        // 1

        Alamofire.request(.GET, ImageUrl)
            .responseImage { response in
                debugPrint(response)

                print(response.request)
                print(response.response)
                debugPrint(response.result)

                if let image = response.result.value {

                    print("image downloaded: \(image)")
                    self.imageView = UIImageView(image: image)
                    self.imageView.frame = CGRect(origin: CGPointMake(0.0, 0.0), size:image.size)
                   // self.imageView.
                    // 2
                    self.scrollView.addSubview(self.imageView)
                    self.scrollView.contentSize = image.size

                    // 3
                    let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "scrollViewDoubleTapped:")
                    doubleTapRecognizer.numberOfTapsRequired = 2
                    doubleTapRecognizer.numberOfTouchesRequired = 1
                    self.scrollView.addGestureRecognizer(doubleTapRecognizer)

                    // 4
                    let scrollViewFrame = self.scrollView.frame
                    let scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width
                    let scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height
                    let minScale = min(scaleWidth, scaleHeight);
                    self.scrollView.minimumZoomScale = minScale;
                    
                    // 5
                    self.scrollView.maximumZoomScale = 3.0
                    self.scrollView.zoomScale = minScale;
                    
                    // 6
                    self.centerScrollViewContents()
                }
        }





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

extension ViewPhotoViewController: UINavigationBarDelegate {
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
    return .TopAttached }
}
