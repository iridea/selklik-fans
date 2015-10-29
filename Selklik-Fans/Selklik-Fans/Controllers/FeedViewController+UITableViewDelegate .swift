//
//  FeedViewController+UITableViewDelegate .swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 20/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation

extension FeedViewController:UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let post = artistPost[indexPath.row]


        let postType = (post.valueForKey("postType") as? String)!
        print(postType)
        if postType == "video"{

            if let videoURLString = (post.valueForKey("videoStdUrl") as? String)
            {
                selectedVideoUrl = videoURLString
                print("videoURLString\(videoURLString)")
                performSegueWithIdentifier("FeedToPlayVideo", sender: self)
            }

        }
}


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "FeedToViewPhoto") {
            let viewPhotoViewController = segue.destinationViewController as! ViewPhotoViewController
            viewPhotoViewController.ImageUrl =  selectedImageUrl
        }

        if (segue.identifier == "FeedToPlayVideo") {
            let destination = segue.destinationViewController as! AVPlayerViewController
            let url = NSURL(string:selectedVideoUrl!)
            destination.player = AVPlayer(URL: url!)
        }

        if (segue.identifier == "FeedToComment") {
            let commentViewController = segue.destinationViewController as! CommentViewController

            commentViewController.postId = self.selectedPostIdComment
            commentViewController.token = self.userToken
            commentViewController.socialMediaType = self.selectedSocialMediaTypeComment
            commentViewController.country = self.selectedCountryComment
        }

        /*
        if (segue.identifier == "artistPostToSinglePost") {
            let singleArtistPostViewController = segue.destinationViewController as! SingleFeedViewController
            singleArtistPostViewController.artistId =  selectedArtistId
            singleArtistPostViewController.countryCode = selectedArtistCountryCode
            singleArtistPostViewController.profileUrl = selectedArtistImageUrl
            singleArtistPostViewController.name = selectedArtistName
            singleArtistPostViewController.isPeek = true
        }*/
    }
}

