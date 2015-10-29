//
//  SingleFeedViewController+UITableViewDataSource.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 21/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import Foundation

extension SingleFeedViewController: UITableViewDataSource {

    //********************************
    func postImageHasBeenTapped(sender:PostImageTapGestureRecognizer){
        print("postImageHasBeenTapped")
        print(sender.imageUrl)
        selectedImageUrl = sender.imageUrl
        self.performSegueWithIdentifier("SingleFeedToViewPhoto", sender: self)
    }
    //********************************



    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("singleartistPost.count:\(artistPost.count)")
        return artistPost.count
    }



    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let post = artistPost[indexPath.row]

        let socialMediaType = post.valueForKey("socialMediaType") as? String
        let postType = post.valueForKey("postType") as? String


        //Download image profile using AlamofireImage
        //let profileImageUrlString = post.valueForKey("profileImageUrl") as? String
        //let profileImageUrl = NSURL(string: profileImageUrlString!)




        switch(socialMediaType!){
        case "twitter":
            if postType == "text" {


                if ((post.valueForKey("twIsRetweet") as? Bool) == true ) {

                    //Retweet Status

                    let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.altRetweetStatusCell, forIndexPath:indexPath) as! AltRetweetStatusCell

                    //let buttonRetweetTitle = (post.valueForKey("name") as? String)! + " retweet"

                    cell.screenNameLabel.text = "@" + (post.valueForKey("twRetweetScreenName") as? String)!
                    cell.statusActiveLabel.text = post.valueForKey("postText") as? String
                    cell.dateTimeLabel.text = String(post.valueForKey("timeStamp") as! NSDate)
                    cell.totalLikeLabel.text =  String(post.valueForKey("totalLike") as! Int) + " favorites"
                    cell.totalRetweetLabel.text = String(post.valueForKey("twTotalRetweet") as! Int) + " retweet"
                    return cell

                }
                else{

                    //Twitter Status
                    let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.altTwitterStatusCell, forIndexPath:indexPath) as! AltTwitterStatusCell

                    cell.screenNameLabel.text = "@" + (post.valueForKey("screenName") as? String)!
                     cell.statusActiveLabel!.text = post.valueForKey("postText") as? String
                    cell.dateTimeLabel.text = String(post.valueForKey("timeStamp") as! NSDate)
                    cell.totalLikeLabel.text =  String(post.valueForKey("totalLike") as! Int) + " favorites"
                    cell.totalRetweetLabel.text = String(post.valueForKey("twTotalRetweet") as! Int) + " retweet"

                    return cell
                }

            }

            if postType == "photo" {

                if ((post.valueForKey("twIsRetweet") as? Bool) == true ) {


                    let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.altRetweetPhotoCell, forIndexPath:indexPath) as! AltRetweetPhotoCell

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
                    //let buttonRetweetTitle = (post.valueForKey("name") as? String)! + " retweet"

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
                    let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.altTwitterPhotoCell, forIndexPath:indexPath) as! AltTwitterPhotoCell


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

                    let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.altRetweetVideoCell, forIndexPath:indexPath) as! AltRetweetVideoCell

                    //retweet control--------
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
                    let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.altTwitterVideoCell, forIndexPath:indexPath) as! AltTwitterVideoCell

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
                let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.altInstagramPhotoCell, forIndexPath:indexPath) as! AltInstagramPhotoCell

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
                //load Post Image

                var placeholderImage = UIImage(named: "placeholder")
                let imageSize = CGSize(width: (post.valueForKey("photoStdWidth") as? CGFloat)!, height: ((post.valueForKey("photoStdHeight") as? CGFloat)!)/2.0)
                placeholderImage = self.photoInfo.resize(image: UIImage(named: "placeholder")!, sizeChange: imageSize, imageScale: 0.1)

                let postPhotoUrl = NSURL(string: (post.valueForKey("photoStdUrl") as? String)!)
                cell.postPhoto.image = nil



                cell.postPhoto.af_setImageWithURL(postPhotoUrl!, placeholderImage: placeholderImage)

                //load rest of the data

                print(post.valueForKey("postText") as? String)
                cell.statusActiveLabel.text = (post.valueForKey("postText") as? String)!
                cell.accountName.text = post.valueForKey("name") as? String

                cell.dateTimeLabel.text = String(post.valueForKey("timeStamp") as! NSDate)

                return cell

            case "video":
                let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.altInstagramVideoCell, forIndexPath:indexPath) as! AltInstagramVideoCell

                var placeholderImage = UIImage(named: "placeholder")
                let imageSize = CGSize(width: (post.valueForKey("videoThumbStdWidth") as? CGFloat)!, height: ((post.valueForKey("videoThumbStdHeight") as? CGFloat)!)/2.0)
                placeholderImage = self.photoInfo.resize(image: UIImage(named: "placeholder")!, sizeChange: imageSize, imageScale: 0.1)
                let postThumbUrl = NSURL(string: (post.valueForKey("videoThumbStdUrl") as? String)!)
                cell.postPhoto.image = nil
                cell.postPhoto.af_setImageWithURL(postThumbUrl!, placeholderImage: placeholderImage)

                //load rest of the data
                cell.statusActiveLabel!.text = post.valueForKey("postText") as? String

                //cell.postStatusLabel.text = post.valueForKey("postText") as? String

                cell.dateTimeLabel.text = String(post.valueForKey("timeStamp") as! NSDate)

                return cell
            default:
                print("undefine instagram type")
            }
            break
        case "facebook":
            switch (postType!) {
            case "status":

                let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.altFacebookStatusCell, forIndexPath:indexPath) as! AltFacebookStatusCell

                cell.name.text = (post.valueForKey("name") as? String)!
                cell.statusActiveLabel!.text = post.valueForKey("postText") as? String
                cell.dateTimeLabel.text = String(post.valueForKey("timeStamp") as! NSDate)

                let totalLike = post.valueForKey("totalLike") as! Int
                var likeString = " Like"
                if totalLike > 1 {
                    likeString += "s"
                }

                let totalComment = post.valueForKey("totalComment") as! Int
                var commentString = " Comment"
                if totalComment > 1 {
                    commentString += "s"
                }

                cell.totalLikeLabel.text =  String(totalLike) + likeString
                cell.totalCommentLabel.setTitle(String(totalComment) + commentString, forState: UIControlState.Normal)
                return cell

            case "photo":
                let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.altFacebookPhotoCell, forIndexPath:indexPath) as! AltFacebookPhotoCell


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

                cell.name.text = (post.valueForKey("name") as? String)!
                cell.statusActiveLabel!.text = post.valueForKey("postText") as? String
                cell.dateTimeLabel.text = String(post.valueForKey("timeStamp") as! NSDate)

                var placeholderImage = UIImage(named: "placeholder")
                let imageSize = CGSize(width: (post.valueForKey("photoStdWidth") as? CGFloat)!, height: ((post.valueForKey("photoStdHeight") as? CGFloat)!)/2.0)
                placeholderImage = self.photoInfo.resize(image: UIImage(named: "placeholder")!, sizeChange: imageSize, imageScale: 0.1)
                let postPhotoUrl = NSURL(string: (post.valueForKey("photoStdUrl") as? String)!)
                cell.postPhoto.image = nil
                cell.postPhoto.af_setImageWithURL(postPhotoUrl!, placeholderImage: placeholderImage)

                let totalLike = post.valueForKey("totalLike") as! Int
                var likeString = " Like"
                if totalLike > 1 {
                    likeString += "s"
                }

                let totalComment = post.valueForKey("totalComment") as! Int
                var commentString = " Comment"
                if totalComment > 1 {
                    commentString += "s"
                }

                cell.totalLikeLabel.text =  String(totalLike) + likeString
                cell.totalCommentLabel.setTitle(String(totalComment) + commentString, forState: UIControlState.Normal)
                return cell

            case "video":
                let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.altFacebookVideoCell, forIndexPath:indexPath) as! AltFacebookVideoCell
                cell.name.text = (post.valueForKey("name") as? String)!
                cell.statusActiveLabel!.text = post.valueForKey("postText") as? String
                cell.dateTimeLabel.text = String(post.valueForKey("timeStamp") as! NSDate)

                var placeholderImage = UIImage(named: "placeholder")
                let imageSize = CGSize(width: (post.valueForKey("videoThumbStdWidth") as? CGFloat)!, height: ((post.valueForKey("videoThumbStdHeight") as? CGFloat)!)/2.0)
                placeholderImage = self.photoInfo.resize(image: UIImage(named: "placeholder")!, sizeChange: imageSize, imageScale: 0.1)
                let postPhotoUrl = NSURL(string: (post.valueForKey("videoThumbStdUrl") as? String)!)
                cell.postThumb.image = nil
                cell.postThumb.af_setImageWithURL(postPhotoUrl!, placeholderImage: placeholderImage)

                let totalLike = post.valueForKey("totalLike") as! Int
                var likeString = " Like"
                if totalLike > 1 {
                    likeString += "s"
                }

                let totalComment = post.valueForKey("totalComment") as! Int
                var commentString = " Comment"
                if totalComment > 1 {
                    commentString += "s"
                }

                cell.totalLikeLabel.text =  String(totalLike) + likeString
                cell.totalCommentLabel.setTitle(String(totalComment) + commentString, forState: UIControlState.Normal)
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