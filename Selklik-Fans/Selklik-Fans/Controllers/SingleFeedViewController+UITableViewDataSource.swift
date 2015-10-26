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
            case "text":
                print("facebook text")
                break
            case "photo":
                print("facebook photo")

                /*
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
                
                //load rest of the data
                cell.statusActiveLabel!.text = post.valueForKey("postText") as? String
                
                cell.accountNameButton.setTitle(post.valueForKey("name") as? String, forState: UIControlState.Normal)
                cell.dateTimeLabel.text = post.valueForKey("timeStamp") as? String
                
                return cell
                */
            case "video":
                print("facebook video")
                break
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