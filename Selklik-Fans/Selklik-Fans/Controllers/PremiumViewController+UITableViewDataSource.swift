//
//  PremiumViewController+UITableViewDataSource.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 16/11/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import Foundation

extension PremiumViewController:UITableViewDataSource {

    //var isImageTab = false
    //********************************
    func postImageHasBeenTapped(sender:PostImageTapGestureRecognizer){
        selectedImageUrl = sender.imageUrl
        self.performSegueWithIdentifier("FeedToViewPhoto", sender: self)
    }

    func showFeedComments(sender:CommentButton) {

        self.selectedPostIdComment = sender.postId
        self.selectedSocialMediaTypeComment = sender.socialMedia
        self.selectedCountryComment = sender.country

        self.performSegueWithIdentifier("FeedToComment", sender: self)
    }
    //********************************



    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistPost.count
    }



    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let post = artistPost[indexPath.row]

        let socialMediaType = post.valueForKey("socialMediaType") as? String
        let postType = post.valueForKey("postType") as? String


        //Download image profile using AlamofireImage
        let profileImageUrlString = post.valueForKey("profileImageUrl") as? String
        let profileImageUrl = NSURL(string: profileImageUrlString!)


        switch(socialMediaType!){
        case "premium":
            switch (postType!) {
            case "photo":
                let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.premiumPhotoCell, forIndexPath:indexPath) as! PremiumPhotoCell

                //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                //sets the user interaction to true, so we can actually track when the image has been tapped
                cell.postPhoto.userInteractionEnabled = true

                //this is where we add the target, since our method to track the taps is in this class
                //we can just type "self", and then put our method name in quotes for the action parameter
                cell.gestureRecognizer.addTarget(self, action: "postImageHasBeenTapped:")

                //finally, this is where we add the gesture recognizer, so it actually functions correctly
                cell.postPhoto.addGestureRecognizer(cell.gestureRecognizer)

                //Custom field in uiimageveew
                cell.gestureRecognizer.imageUrl = (post.valueForKey("photoStdUrl") as? String)!
                //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

                //totalComment Button -------------------------
                var totalCommentString = " Comment"

                if let totalComment = post.valueForKey("totalComment") as? Int {
                    if totalComment > 1 {
                        totalCommentString += "s"
                    }
                    totalCommentString = String(totalComment) + totalCommentString
                }

                cell.totalCommentButton.setTitle(totalCommentString, forState: UIControlState.Normal)
                cell.totalCommentButton.addTarget(self, action: "showFeedComments:", forControlEvents: .TouchUpInside)

                cell.totalCommentButton.postId = (post.valueForKey("postId") as? String)!
                cell.totalCommentButton.country = (post.valueForKey("country") as? String)!
                cell.totalCommentButton.socialMedia = socialMediaType!
                //---------------------------------------------

                //load profile image
                var placeholderImage = UIImage(named: "UserIcon")
                cell.profilePictureImageView.image = placeholderImage
                cell.profilePictureImageView.af_setImageWithURL(profileImageUrl!, placeholderImage: placeholderImage)

                //load Post Image

                let imageSize = CGSize(width: (post.valueForKey("photoStdWidth") as? CGFloat)!, height: ((post.valueForKey("photoStdHeight") as? CGFloat)!)/2.0)


                //system sometime cannot find 'placeholder' image in Assets library.
                //so i prepare a "placeholder-backup"
                if let ph = UIImage(named: "placeholder") {
                    placeholderImage = self.photoInfo.resize(image: ph, sizeChange: imageSize, imageScale: 0.1)
                }else{
                    let ph = UIImage(named: "placeholder-backup")
                    placeholderImage = self.photoInfo.resize(image: ph!, sizeChange: imageSize, imageScale: 0.1)

                }

                placeholderImage = self.photoInfo.resize(image: UIImage(named: "placeholder")!, sizeChange: imageSize, imageScale: 0.1)
                let postPhotoUrl = NSURL(string: (post.valueForKey("photoStdUrl") as? String)!)
                cell.postPhoto.image = nil


                cell.postPhoto.af_setImageWithURL(postPhotoUrl!, placeholderImage: placeholderImage)
                cell.dateTimeLabel.text = String(post.valueForKey("timeStamp") as! NSDate)
                //load rest of the data
                cell.statusActiveLabel!.text = post.valueForKey("postText") as? String

                //cell.postStatusLabel.text = post.valueForKey("postText") as? String
                cell.accountNameButton.setTitle(post.valueForKey("screenName") as? String, forState: UIControlState.Normal)

                cell.totalLikeLabel.text =  String(post.valueForKey("totalLike") as! Int) + " favorites"

                //Detail button *************************
                cell.accountNameButton.id = (post.valueForKey("artistId") as? String)!
                cell.accountNameButton.countryCode = (post.valueForKey("country") as? String)!
                cell.accountNameButton.imageUrl = (post.valueForKey("profileImageUrl") as? String)!
                cell.accountNameButton.name = (post.valueForKey("screenName") as? String)!
                cell.accountNameButton.addTarget(self, action: "showArtistSinglePost:", forControlEvents: .TouchUpInside)

                //***************************************
                return cell
            case "video":
                let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.premiumVideoCell, forIndexPath:indexPath) as! PremiumVideoCell

                //totalComment Button -------------------------
                var totalCommentString = " Comment"

                if let totalComment = post.valueForKey("totalComment") as? Int {
                    if totalComment > 1 {
                        totalCommentString += "s"
                    }
                    totalCommentString = String(totalComment) + totalCommentString
                }
                
                cell.totalCommentButton.setTitle(totalCommentString, forState: UIControlState.Normal)
                cell.totalCommentButton.addTarget(self, action: "showFeedComments:", forControlEvents: .TouchUpInside)
                
                cell.totalCommentButton.postId = (post.valueForKey("postId") as? String)!
                cell.totalCommentButton.country = (post.valueForKey("country") as? String)!
                cell.totalCommentButton.socialMedia = socialMediaType!
                //---------------------------------------------
                
                
                //load profile image
                var placeholderImage = UIImage(named: "UserIcon")
                cell.profilePictureImageView.image = placeholderImage
                cell.profilePictureImageView.af_setImageWithURL(profileImageUrl!, placeholderImage: placeholderImage)
                
                //load Post Image
                placeholderImage = UIImage(named: "placeholder")
                
                let imageSize = CGSize(width: (post.valueForKey("videoThumbStdWidth") as? CGFloat)!, height: ((post.valueForKey("videoThumbStdHeight") as? CGFloat)!)/2.0)
                
                //print("imageSize:\(imageSize)")
                placeholderImage = self.photoInfo.resize(image: UIImage(named: "placeholder")!, sizeChange: imageSize, imageScale: 0.1)
                let postThumbUrl = NSURL(string: (post.valueForKey("videoThumbStdUrl") as? String)!)
                //cell.postThumb.image = nil
                cell.postThumb.af_setImageWithURL(postThumbUrl!, placeholderImage: placeholderImage)
                cell.dateTimeLabel.text = String(post.valueForKey("timeStamp") as! NSDate)
                //load rest of the data
                cell.statusActiveLabel!.text = post.valueForKey("postText") as? String
                
                //cell.postStatusLabel.text = post.valueForKey("postText") as? String
                cell.accountNameButton.setTitle(post.valueForKey("screenName") as? String, forState: UIControlState.Normal)
                
                cell.totalLikeLabel.text =  String(post.valueForKey("totalLike") as! Int) + " favorites"
                
                //Detail button *************************
                cell.accountNameButton.id = (post.valueForKey("artistId") as? String)!
                cell.accountNameButton.countryCode = (post.valueForKey("country") as? String)!
                cell.accountNameButton.imageUrl = (post.valueForKey("profileImageUrl") as? String)!
                cell.accountNameButton.name = (post.valueForKey("screenName") as? String)!
                cell.accountNameButton.addTarget(self, action: "showArtistSinglePost:", forControlEvents: .TouchUpInside)
                //***************************************
                
                
                return cell
            default:
                break
            }
        default:
            print("undefine")
        }
        
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "mycell")
        
        cell.textLabel!.text = socialMediaType! + " - " + postType!
        
        return cell
        
    }
}
