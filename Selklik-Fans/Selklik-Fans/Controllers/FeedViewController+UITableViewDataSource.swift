//
//  FeedViewController+UITableViewDataSource.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 15/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import Foundation

extension FeedViewController: UITableViewDataSource {

   
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
        case "twitter":
            if postType == "text" {


                if ((post.valueForKey("twIsRetweet") as? Bool) == true ) {

                    //Retweet Status

                    let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.retweetStatusCell, forIndexPath:indexPath) as! RetweetStatusCell

                    let buttonRetweetTitle = (post.valueForKey("name") as? String)! + " retweet"
                    cell.retweetButton.setTitle(buttonRetweetTitle, forState: UIControlState.Normal)

                    cell.profilePictureImageView.image = UIImage(named: "UserIcon")
                    cell.profilePictureImageView.af_setImageWithURL(profileImageUrl!)

                    cell.accountNameLabel.text = (post.valueForKey("twRetweetName") as? String)!
                    cell.screenNameLabel.text = "@" + (post.valueForKey("twRetweetScreenName") as? String)!
                    cell.statusActiveLabel.text = post.valueForKey("postText") as? String
                    cell.dateTimeLabel.text = String(post.valueForKey("timeStamp") as! NSDate)
                    cell.totalLikeLabel.text =  String(post.valueForKey("totalLike") as! Int) + " favorites"
                    cell.totalRetweetLabel.text = String(post.valueForKey("twTotalRetweet") as! Int) + " retweet"
                    return cell
                }
                else{

                    //Twitter Status
                    let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.twitterStatusCell, forIndexPath:indexPath) as! TwitterStatusCell

                    cell.profilePictureImageView.image = UIImage(named: "UserIcon")
                    cell.profilePictureImageView.af_setImageWithURL(profileImageUrl!)


                    cell.accountNameButton.setTitle(post.valueForKey("name") as? String, forState: UIControlState.Normal)
                    cell.screenNameLabel.text = "@" + (post.valueForKey("screenName") as? String)!
                    cell.statusActiveLabel.text = post.valueForKey("postText") as? String
                    cell.dateTimeLabel.text = String(post.valueForKey("timeStamp") as! NSDate)
                    cell.totalLikeLabel.text =  String(post.valueForKey("totalLike") as! Int) + " favorites"
                    cell.totalRetweetLabel.text = String(post.valueForKey("twTotalRetweet") as! Int) + " retweet"

                    return cell
                }

            }

            if postType == "photo" {

                if ((post.valueForKey("twIsRetweet") as? Bool) == true ) {

                    let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.retweetPhotoCell, forIndexPath:indexPath) as! RetweetPhotoCell

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


                    //retweet control
                    let buttonRetweetTitle = (post.valueForKey("name") as? String)! + " retweet"
                    cell.retweetButton.setTitle(buttonRetweetTitle, forState: UIControlState.Normal)

                    cell.profilePictureImageView.image = UIImage(named: "UserIcon")
                    cell.profilePictureImageView.af_setImageWithURL(profileImageUrl!)


                    cell.accountNameLabel.text = (post.valueForKey("twRetweetName") as? String)!
                    cell.screenNameLabel.text = "@" + (post.valueForKey("twRetweetScreenName") as? String)!
                    cell.statusActiveLabel.text = post.valueForKey("postText") as? String
                    cell.dateTimeLabel.text = String(post.valueForKey("timeStamp") as! NSDate)
                    cell.totalLikeLabel.text =  String(post.valueForKey("totalLike") as! Int) + " favorites"
                    cell.totalRetweetLabel.text = String(post.valueForKey("twTotalRetweet") as! Int) + " retweet"

                    //load Post Image
                    let imageSize = CGSize(width: (post.valueForKey("photoStdWidth") as? CGFloat)!, height: ((post.valueForKey("photoStdHeight") as? CGFloat)!)/2.0)

                    var placeholderImage = UIImage(named: "placeholder")
                    placeholderImage = self.photoInfo.resize(image: UIImage(named: "placeholder")!, sizeChange: imageSize, imageScale: 0.1)
                    let postPhotoUrl = NSURL(string: (post.valueForKey("photoStdUrl") as? String)!)
                    cell.postPhoto.image = nil
                    cell.postPhoto.af_setImageWithURL(postPhotoUrl!, placeholderImage: placeholderImage)
                    
                    return cell

                }
                else {
                    let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.twitterPhotoCell, forIndexPath:indexPath) as! TwitterPhotoCell


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



                    cell.profilePictureImageView.image = UIImage(named: "UserIcon")
                    cell.profilePictureImageView.af_setImageWithURL(profileImageUrl!)

                    cell.accountNameButton.setTitle(post.valueForKey("name") as? String, forState: UIControlState.Normal)
                    cell.screenNameLabel.text = "@" + (post.valueForKey("screenName") as? String)!
                    cell.statusActiveLabel.text = post.valueForKey("postText") as? String
                    cell.dateTimeLabel.text = String(post.valueForKey("timeStamp") as! NSDate)
                    cell.totalLikeLabel.text =  String(post.valueForKey("totalLike") as! Int) + " favorites"
                    cell.totalRetweetLabel.text = String(post.valueForKey("twTotalRetweet") as! Int) + " retweet"

                    //load Post Image
                    let imageSize = CGSize(width: (post.valueForKey("photoStdWidth") as? CGFloat)!, height: ((post.valueForKey("photoStdHeight") as? CGFloat)!)/2.0)

                    var placeholderImage = UIImage(named: "placeholder")
                    placeholderImage = self.photoInfo.resize(image: UIImage(named: "placeholder")!, sizeChange: imageSize, imageScale: 0.1)
                    let postPhotoUrl = NSURL(string: (post.valueForKey("photoStdUrl") as? String)!)
                    cell.postPhoto.image = nil
                    cell.postPhoto.af_setImageWithURL(postPhotoUrl!, placeholderImage: placeholderImage)

                    return cell

                }
            }

            if postType == "video" {
                if ((post.valueForKey("twIsRetweet") as? Bool) == true ) {

                    let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.retweetVideoCell, forIndexPath:indexPath) as! RetweetVideoCell

                    //retweet control--------
                    let buttonRetweetTitle = (post.valueForKey("name") as? String)! + " retweet"
                    cell.retweetButton.setTitle(buttonRetweetTitle, forState: UIControlState.Normal)

                    cell.profilePictureImageView.image = UIImage(named: "UserIcon")
                    cell.profilePictureImageView.af_setImageWithURL(profileImageUrl!)
                    cell.accountNameLabel.text = (post.valueForKey("twRetweetName") as? String)!
                    //------------------------

                    cell.profilePictureImageView.image = UIImage(named: "UserIcon")
                    cell.profilePictureImageView.af_setImageWithURL(profileImageUrl!)

                    cell.screenNameLabel.text = "@" + (post.valueForKey("screenName") as? String)!
                    cell.statusActiveLabel.text = post.valueForKey("postText") as? String
                    cell.dateTimeLabel.text = String(post.valueForKey("timeStamp") as! NSDate)
                    cell.totalLikeLabel.text =  String(post.valueForKey("totalLike") as! Int) + " favorites"
                    cell.totalRetweetLabel.text = String(post.valueForKey("twTotalRetweet") as! Int) + " retweet"

                    //load thumb Image
                    let imageSize = CGSize(width: (post.valueForKey("videoThumbStdWidth") as? CGFloat)!, height: ((post.valueForKey("videoThumbStdHeight") as? CGFloat)!)/2.0)

                    var placeholderImage = UIImage(named: "placeholder")
                    placeholderImage = self.photoInfo.resize(image: UIImage(named: "placeholder")!, sizeChange: imageSize, imageScale: 0.1)
                    let postPhotoUrl = NSURL(string: (post.valueForKey("videoThumbStdUrl") as? String)!)
                    cell.postThumb.image = nil
                    cell.postThumb.af_setImageWithURL(postPhotoUrl!, placeholderImage: placeholderImage)
                    
                    return cell
                    
                }
                else{
                    let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.twitterVideoCell, forIndexPath:indexPath) as! TwitterVideoCell

                    cell.profilePictureImageView.image = UIImage(named: "UserIcon")
                    cell.profilePictureImageView.af_setImageWithURL(profileImageUrl!)

                    cell.accountNameButton.setTitle(post.valueForKey("name") as? String, forState: UIControlState.Normal)
                    cell.screenNameLabel.text = "@" + (post.valueForKey("screenName") as? String)!
                    cell.statusActiveLabel.text = post.valueForKey("postText") as? String
                    cell.dateTimeLabel.text = String(post.valueForKey("timeStamp") as! NSDate)
                    cell.totalLikeLabel.text =  String(post.valueForKey("totalLike") as! Int) + " favorites"
                    cell.totalRetweetLabel.text = String(post.valueForKey("twTotalRetweet") as! Int) + " retweet"

                    //load thumb Image
                    let imageSize = CGSize(width: (post.valueForKey("videoThumbStdWidth") as? CGFloat)!, height: ((post.valueForKey("videoThumbStdHeight") as? CGFloat)!)/2.0)

                    var placeholderImage = UIImage(named: "placeholder")
                    placeholderImage = self.photoInfo.resize(image: UIImage(named: "placeholder")!, sizeChange: imageSize, imageScale: 0.1)
                    let postPhotoUrl = NSURL(string: (post.valueForKey("videoThumbStdUrl") as? String)!)
                    cell.postThumb.image = nil
                    cell.postThumb.af_setImageWithURL(postPhotoUrl!, placeholderImage: placeholderImage)

                    return cell
                }


            }

            break
        case "instagram":
            switch (postType!) {
            case "photo":
                let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.instagramPhotoCell, forIndexPath:indexPath) as! InstagramPhotoCell

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
                placeholderImage = UIImage(named: "placeholder")
                let imageSize = CGSize(width: (post.valueForKey("photoStdWidth") as? CGFloat)!, height: ((post.valueForKey("photoStdHeight") as? CGFloat)!)/2.0)
                placeholderImage = self.photoInfo.resize(image: UIImage(named: "placeholder")!, sizeChange: imageSize, imageScale: 0.1)
                let postPhotoUrl = NSURL(string: (post.valueForKey("photoStdUrl") as? String)!)
                cell.postPhoto.image = nil



                cell.postPhoto.af_setImageWithURL(postPhotoUrl!, placeholderImage: placeholderImage)
                cell.dateTimeLabel.text = String(post.valueForKey("timeStamp") as! NSDate)
                //load rest of the data
                cell.statusActiveLabel!.text = post.valueForKey("postText") as? String

                //cell.postStatusLabel.text = post.valueForKey("postText") as? String
                cell.accountNameButton.setTitle(post.valueForKey("name") as? String, forState: UIControlState.Normal)
                
                return cell
                
            case "video":
                let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.instagramVideoCell, forIndexPath:indexPath) as! InstagramVideoCell

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
                placeholderImage = self.photoInfo.resize(image: UIImage(named: "placeholder")!, sizeChange: imageSize, imageScale: 0.1)
                let postThumbUrl = NSURL(string: (post.valueForKey("videoThumbStdUrl") as? String)!)
                cell.postThumb.image = nil
                cell.postThumb.af_setImageWithURL(postThumbUrl!, placeholderImage: placeholderImage)
                cell.dateTimeLabel.text = String(post.valueForKey("timeStamp") as! NSDate)
                //load rest of the data
                cell.statusActiveLabel!.text = post.valueForKey("postText") as? String

                //cell.postStatusLabel.text = post.valueForKey("postText") as? String
                cell.accountNameButton.setTitle(post.valueForKey("name") as? String, forState: UIControlState.Normal)

                
                return cell
            default:
                print("undefine instagram type")
            }
            break
        case "facebook":
            switch (postType!) {
            case "text":
                print("facebook text")
                break
            case "photo":
                print("facebook photo")

                let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.facebookPhotoCell, forIndexPath:indexPath) as! FacebookPhotoCell

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



                //load profile image
                var placeholderImage = UIImage(named: "UserIcon")
                cell.profilePictureImageView.image = nil//UIImage(named: "UserIcon")
                cell.profilePictureImageView.af_setImageWithURL(profileImageUrl!, placeholderImage: placeholderImage)

                //load Post Image
                placeholderImage = UIImage(named: "placeholder")
                let imageSize = CGSize(width: (post.valueForKey("photoStdWidth") as? CGFloat)!, height: ((post.valueForKey("photoStdHeight") as? CGFloat)!)/2.0)

                placeholderImage = self.photoInfo.resize(image: UIImage(named: "placeholder")!, sizeChange: imageSize, imageScale: 0.1)
                let postPhotoUrl = NSURL(string: (post.valueForKey("photoStdUrl") as? String)!)
                cell.postPhoto.image = nil
                cell.postPhoto.af_setImageWithURL(postPhotoUrl!, placeholderImage: placeholderImage)
                cell.dateTimeLabel.text = String(post.valueForKey("timeStamp") as! NSDate)
                //load rest of the data
                cell.statusActiveLabel!.text = post.valueForKey("postText") as? String

                cell.accountNameButton.setTitle(post.valueForKey("name") as? String, forState: UIControlState.Normal)
                
                cell.totalLikeLabel.text =  String(post.valueForKey("totalLike") as! Int) + " likes"
                let totalComment = post.valueForKey("totalComment") as? Int
                var totalCommentString = String(totalComment!)

                if (totalComment == 1){
                    totalCommentString += " Comment"
                }else{
                    totalCommentString += " Comments"
                }

                cell.totalCommentButton.setTitle(totalCommentString, forState: UIControlState.Normal)

                return cell

            case "video":
                let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.facebookVideoCell, forIndexPath:indexPath) as! FacebookVideoCell

                //load profile image
                var placeholderImage = UIImage(named: "UserIcon")
                cell.profilePictureImageView.image = nil//UIImage(named: "UserIcon")
                cell.profilePictureImageView.af_setImageWithURL(profileImageUrl!, placeholderImage: placeholderImage)

                //load Post Image
                placeholderImage = UIImage(named: "placeholder")
                let imageSize = CGSize(width: (post.valueForKey("videoThumbStdWidth") as? CGFloat)!, height: ((post.valueForKey("videoThumbStdHeight") as? CGFloat)!)/2.0)

                placeholderImage = self.photoInfo.resize(image: UIImage(named: "placeholder")!, sizeChange: imageSize, imageScale: 0.1)
               

                let postPhotoUrl = NSURL(string: (post.valueForKey("videoThumbStdUrl") as? String)!)
                cell.postThumb.image = nil
                cell.postThumb.af_setImageWithURL(postPhotoUrl!, placeholderImage: placeholderImage)

                //load rest of the data
                cell.statusActiveLabel!.text = post.valueForKey("postText") as? String
                cell.dateTimeLabel.text = String(post.valueForKey("timeStamp") as! NSDate)
                cell.accountNameButton.setTitle(post.valueForKey("name") as? String, forState: UIControlState.Normal)

                cell.totalLikeLabel.text =  String(post.valueForKey("totalLike") as! Int) + " likes"
                let totalComment = post.valueForKey("totalComment") as? Int
                var totalCommentString = String(totalComment!)

                if (totalComment == 1){
                    totalCommentString += " Comment"
                }else{
                    totalCommentString += " Comments"
                }

                cell.totalCommentButton.setTitle(totalCommentString, forState: UIControlState.Normal)
                
                return cell
            case "link":
                print("facebook link")
                break
            default:
                print("unknown facebook postType: \(postType)")
                
            }
            break
        case "premium":
            print("Premium")
            break
        default:
            print("undefine")
        }
        
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "mycell")
        
        cell.textLabel!.text = socialMediaType! + " - " + postType!
        
        return cell
        
    }
}