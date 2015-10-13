//
//  FeedViewController.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 9/27/15.
//  Copyright © 2015 Selklik. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class FeedViewController: UIViewController {

    //MARK: - Variable
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var managedContext: NSManagedObjectContext!
    var userToken:String!
    var allPosts = [Post]()
    var newPost:Post!
    var artistPost = [NSManagedObject]()
    let userInfo = UserInfo()

    var fetchedResultsController: NSFetchedResultsController!

    //MARK: - IBOutlet
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var feedTableView: UITableView!

    //variable for loading HUD
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()

    struct CellIdentifiers {
        static let twitterStatusCell = "TwitterStatusCell"
        static let twitterPhotoCell = "TwitterPhotoCell"
        static let twitterVideoCell = "TwitterVideoCell"
        static let retweetTwitterStatusCell = "RetweetTwitterStatusCell"
        static let retweetTwitterPhotoCell = "RetweetTwitterPhotoCell"
        static let retweetTwitterVideoCell = "RetweetTwitterVideoCell"

        static let facebookStatusCell = "FacebookStatusCell"
        static let facebookPhotoCell = "FacebookPhotoCell"
        static let facebookVideoCell = "FacebookVideoCell"
        static let facebookLinkCell = "FacebookLinkCell"

        static let instagramPhotoCell = "InstagramPhotoCell"
        static let instagramVideoCell = "InstagramVideoCell"

        static let twitterSingleStatusFeed = "TwitterSingleStatusFeed"

    }

    func registerNib(){
        var cellNib = UINib(nibName: CellIdentifiers.facebookPhotoCell, bundle: nil)
        feedTableView.registerNib(cellNib, forCellReuseIdentifier: CellIdentifiers.facebookPhotoCell)
        cellNib = UINib(nibName: CellIdentifiers.twitterStatusCell, bundle: nil)
        feedTableView.registerNib(cellNib, forCellReuseIdentifier: CellIdentifiers.twitterStatusCell)
    }



    @IBAction func reloadButton(sender: AnyObject) {
        self.getFeedFromCoreData()
    }

    //MARK: - Custom Function

    //self.progressBarDisplayer("Preparing data", true)
    //self.messageFrame.removeFromSuperview()
    //view.userInteractionEnabled = false
    func progressBarDisplayer(msg:String, _ indicator:Bool ) {

        view.userInteractionEnabled = false

        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor.whiteColor()
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 50 , width: 180, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        if indicator {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.startAnimating()
            messageFrame.addSubview(activityIndicator)
        }
        messageFrame.addSubview(strLabel)
        view.addSubview(messageFrame)
    }

    func clearAllPost() {

        let fetchPosts = NSFetchRequest(entityName: "Post")

        do  {
            let fetchedEntities = try managedContext.executeFetchRequest(fetchPosts) as? [Post]

            for entity in fetchedEntities! {
                managedContext.deleteObject(entity)
            }

        }
        catch let fetchError as NSError {
            print("Fetch Post for delete error: \(fetchError.localizedDescription)")
        }

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save: \(error)")
        }
    }



    func populateFeed() {

        let postEntity = NSEntityDescription.entityForName("Post",inManagedObjectContext: managedContext)

        Alamofire.request(.GET, API.artistFeedUrl, parameters: ["token": userToken, "country": Setting.malaysia, "limit" : "15"]).responseJSON {
            _, _, result in

            print("MASUK FetchRemoteFeedData - ALAMOFIRE")
            let json = JSON(result.value!)

            print(json)

            for (_,subJson):(String, JSON) in json["result"] {

                let newPost = Post(entity: postEntity!,
                    insertIntoManagedObjectContext: self.managedContext)

                //MARK: - Standard Data
                if let artistId = subJson["artist_id"].string {
                    newPost.artistId = artistId
                }else{
                    print("unable to read JSON data artist_id")
                }

                if let name = subJson["artist_name"].string {
                    newPost.name = name
                }else{
                    print("unable to read JSON data artist_name")
                }

                if let screenName = subJson["artist_screen_name"].string {
                    newPost.screenName = screenName
                }else{
                    print("unable to read JSON data artist_screen_name")
                }

                if let profileImageUrl = subJson["artist_img"].string {
                    newPost.profileImageUrl = profileImageUrl
                }else{
                    print("unable to read JSON data artist_img")
                }

                if let timeStamp = subJson["timestamp"].string {
                    //artistPost.timeStamp = Date(timeStamp)
                }else{
                    print("unable to read JSON data timestamp")
                }

                if let postId = subJson["post_id"].string {
                    newPost.postId = postId
                }else{
                    print("unable to read JSON data post_id")
                }

                if let postLink = subJson["post_link"].string {
                    newPost.postLink = postLink
                }else{
                    print("unable to read JSON data post_link")
                }

                if let postText = subJson["post_text"].string {
                    newPost.postText = postText
                }else{
                    print("unable to read JSON data post_text")
                }

                if let socialMediaType = subJson["social_media"].string {
                    newPost.socialMediaType = socialMediaType
                }else{
                    print("unable to read JSON data social_media")
                }

                if let postType = subJson["post_type"].string {
                    newPost.postType = postType
                }else{
                    print("unable to read JSON data post_type")
                }

                //Check Social Media
                if let socialMediaType = subJson["social_media"].string {

                    switch socialMediaType {
                    case "twitter": //------------TWITTER------------


                        //isRetweet
                        if let isRetweet = subJson["is_retweet"].int {

                            newPost.twIsRetweet = isRetweet

                            if isRetweet == 1 {
                                newPost.twRetweetName = subJson["rt_name"].string
                                newPost.twRetweetScreenName = subJson["rt_screen_name"].string
                            }

                        }else{
                            print("Unable to read JSON data is_retweet")
                        }
                        //----------------------------------------------

                        //Favourite
                        if let totalLike = subJson["favorites"].string {
                            newPost.totalLike = Int(totalLike)
                        }else{
                            print("unable to read JSON data favorites")
                        }//---------------------------------------------


                        //total retweet
                        if let twTotalRetweet = subJson["retweets"].string {
                            newPost.twTotalRetweet = Int(twTotalRetweet)
                        }else{
                            print("unable to read JSON data retweets")
                        }//---------------------------------------------


                        //==============================================
                        if let postType = subJson["post_type"].string {
                            switch postType {
                            case "text":
                                print("twitter text")
                                break
                            case "photo":
                                if let photoStdUrl = subJson["post_photo"]["medium"]["photo_link"].string {
                                    newPost.photoStdUrl = photoStdUrl
                                }

                                if let photoStdWidth = subJson["post_photo"]["medium"]["photo_width"].string {
                                    newPost.photoStdWidth = Float(photoStdWidth)
                                }

                                if let photoStdHeight = subJson["post_photo"]["medium"]["photo_height"].string {
                                    newPost.photoStdHeight = Float(photoStdHeight)
                                }
                                break

                            case "video":
                                if let videoStdUrl = subJson["post_video"]["standard"]["video_link"].string {
                                    newPost.videoStdUrl = videoStdUrl
                                }

                                if let videoStdUrl = subJson["post_video"]["standard"]["video_link"].string {
                                    newPost.videoStdUrl = videoStdUrl
                                }

                                if let videoThumbStdUrl = subJson["post_thumb"]["medium"]["thumb_link"].string {
                                    newPost.videoThumbStdUrl = videoThumbStdUrl
                                }

                                if let videoThumbStdWidth = subJson["post_thumb"]["medium"]["thumb_width"].string {
                                    newPost.videoThumbStdWidth = Float(videoThumbStdWidth)
                                }

                                if let videoThumbStdHeight = subJson["post_thumb"]["medium"]["thumb_height"].string {
                                    newPost.videoThumbStdHeight = Float(videoThumbStdHeight)
                                }
                                break

                            default:
                                print("Unknown twitter postType format: \(postType)")
                            }

                        }else{
                            print("Unable to read JSON data post_type")
                        }
                        break
                    case "instagram": //------------INSTAGRAM------------
                        if let postType = subJson["post_type"].string {

                            //Likes
                            if let totalLike = subJson["likes"].string {

                                newPost.totalLike = Int(totalLike)
                            }else{
                                print("unable to read JSON data likes")
                            }//-------------------------------------------

                            //Comments
                            if let totalComment = subJson["comments"].string {

                                newPost.totalComment = Int(totalComment)
                            }else{
                                print("unable to read JSON data comments")
                            }//--------------------------------------------


                            switch postType {

                            case "photo":
                                if let photoStdUrl = subJson["post_photo"]["standard"]["photo_link"].string {
                                    newPost.photoStdUrl = photoStdUrl
                                }

                                if let photoStdWidth = subJson["post_photo"]["standard"]["photo_width"].string {
                                    newPost.photoStdWidth = Float(photoStdWidth)
                                }

                                if let photoStdHeight = subJson["post_photo"]["standard"]["photo_height"].string {
                                    newPost.photoStdHeight = Float(photoStdHeight)
                                }
                                break

                            case "video":
                                if let videoStdUrl = subJson["post_video"]["standard"]["video_link"].string {
                                    newPost.videoStdUrl = videoStdUrl
                                }

                                if let videoStdUrl = subJson["post_video"]["standard"]["video_link"].string {
                                    newPost.videoStdUrl = videoStdUrl
                                }

                                //Thumb
                                if let videoThumbStdUrl = subJson["post_thumb"]["standard"]["thumb_link"].string {
                                    newPost.videoThumbStdUrl = videoThumbStdUrl
                                }

                                if let videoThumbStdWidth = subJson["post_thumb"]["standard"]["thumb_width"].string {
                                    newPost.videoThumbStdWidth = Float(videoThumbStdWidth)
                                }

                                if let videoThumbStdHeight = subJson["post_thumb"]["standard"]["thumb_height"].string {
                                    newPost.videoThumbStdHeight = Float(videoThumbStdHeight)
                                }
                                break

                            default:
                                print("Unknown instagram postType format: \(postType) ")
                            }
                        }else{
                            print("Unable to read instagram JSON data post_type")
                        }
                        break
                    case "facebook": //------------FACEBOOK------------
                        if let postType = subJson["post_type"].string {

                            //Likes
                            if let totalLike = subJson["likes"].string {

                                newPost.totalLike = Int(totalLike)
                            }else{
                                print("unable to read JSON data likes")
                            }//---------------------------------------------

                            //Comments
                            if let totalComment = subJson["comments"].string {

                                newPost.totalComment = Int(totalComment)
                            }else{
                                print("unable to read JSON data comments")
                            }//---------------------------------------------

                            //Shared
                            if let fbTotalShare = subJson["shared"].string {
                                newPost.fbTotalShare = Int(fbTotalShare)
                            }else{
                                print("unable to read JSON data likes")
                            }//---------------------------------------------


                            switch postType {
                            case "text":
                                print("facebook text")
                                break
                            case "photo":
                                if let photoStdUrl = subJson["post_photo"]["standard"]["photo_link"].string {
                                    newPost.photoStdUrl = photoStdUrl
                                }

                                if let photoStdWidth = subJson["post_photo"]["standard"]["photo_width"].string {
                                    newPost.photoStdWidth = Float(photoStdWidth)
                                }

                                if let photoStdHeight = subJson["post_photo"]["standard"]["photo_height"].string {
                                    newPost.photoStdHeight = Float(photoStdHeight)
                                }
                                break

                            case "video":
                                if let videoStdUrl = subJson["post_video"]["standard"]["video_link"].string {
                                    newPost.videoStdUrl = videoStdUrl
                                }

                                if let videoStdUrl = subJson["post_video"]["standard"]["video_link"].string {
                                    newPost.videoStdUrl = videoStdUrl
                                }

                                //Thumb
                                if let videoThumbStdUrl = subJson["post_thumb"]["standard"]["thumb_link"].string {
                                    newPost.videoThumbStdUrl = videoThumbStdUrl
                                }

                                if let videoThumbStdWidth = subJson["post_thumb"]["standard"]["thumb_width"].string {
                                    newPost.videoThumbStdWidth = Float(videoThumbStdWidth)
                                }

                                if let videoThumbStdHeight = subJson["post_thumb"]["standard"]["thumb_height"].string {
                                    newPost.videoThumbStdHeight = Float(videoThumbStdHeight)
                                }
                                break

                            case "link":
                                if let fbContentLink = subJson["post_shared"]["standard"]["shared_link"].string {
                                    newPost.fbContentLink = fbContentLink
                                }

                                if let fbContentLinkImageUrl = subJson["post_shared"]["standard"]["link_photo"].string {
                                    newPost.fbContentLinkImageUrl = fbContentLinkImageUrl
                                }

                                if let fbContentLinkTitle = subJson["post_shared"]["standard"]["link_title"].string {
                                    newPost.fbContentLinkTitle = fbContentLinkTitle
                                }

                                if let fbContentLinkText = subJson["post_shared"]["standard"]["link_text"].string {
                                    newPost.fbContentLinkText = fbContentLinkText
                                }
                                break

                            default:
                                print("Unknown facebook postType format: \(postType) ")
                            }
                        }
                        break
                    case "premium": //------------PREMIUM------------
                        if let postType = subJson["post_type"].string {
                            switch postType {
                            case "photo":
                                print("premium photo")
                                print("-------------------")
                                break

                            case "video":
                                print("premium video")
                                print("-------------------")
                                break

                            default:
                                print("Unknown premium postType format: \(postType) ")
                            }
                        }
                        break
                    default:
                        print("unable to read JSON data social_media")
                    }

                }





            }// End of For-Loop JSON data

            dispatch_async(dispatch_get_main_queue()) {
                do {
                    try self.managedContext.save()
                } catch let error as NSError {
                    print("Could not save: \(error)")
                }

                self.getFeedFromCoreData()
                self.feedTableView.reloadData()

                self.messageFrame.removeFromSuperview()
                self.view.userInteractionEnabled = true
            }


        }// End of Alamofire

    } //End of populateFeed()

    //MARK: - Default Function
    override func viewDidLoad() {
        super.viewDidLoad()

        feedTableView.rowHeight = UITableViewAutomaticDimension
        feedTableView.estimatedRowHeight = 66

         registerNib()
        
        feedTableView.dataSource = self



        self.managedContext = appDelegate.coreDataStack.context
        self.userToken = userInfo.getTokenFromCoreData(managedContext)

        self.progressBarDisplayer("Loading data", true)
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let fetchRequest = NSFetchRequest(entityName: "Post")
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            if results.count > 0 {
                clearAllPost()
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        //insert to core data the new posts received from server
        populateFeed()
        
    }
    
    func getFeedFromCoreData() {
        let fetchRequest = NSFetchRequest(entityName: "Post")
        
        
        do  {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            artistPost = results as! [NSManagedObject]
            
        }
        catch let fetchError as NSError {
            print("Fetch access in AppDelegate error: \(fetchError.localizedDescription)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension FeedViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistPost.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //var cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        let post = artistPost[indexPath.row]

        let socialMediaType = post.valueForKey("socialMediaType") as? String
        let postType = post.valueForKey("postType") as? String

        switch(socialMediaType!){
        case "twitter":
            if postType == "text" {

                let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.twitterStatusCell, forIndexPath:indexPath) as! TwitterStatusCell

                
                cell.accountNameButton.setTitle(post.valueForKey("name") as? String, forState: UIControlState.Normal)
                cell.screenNameLabel.text = "@" + (post.valueForKey("screenName") as? String)!
                cell.postStatusLabel.text = post.valueForKey("postText") as? String
                cell.dateTimeLabel.text = post.valueForKey("timeStamp") as? String
                cell.totalLikeLabel.text =  String(post.valueForKey("totalLike") as! Int) + " favorites"
                cell.totalRetweetLabel.text = String(post.valueForKey("twTotalRetweet") as! Int) + " retweet"

                /*
                @IBOutlet weak var accountNameButton: UIButton!
                @IBOutlet weak var profilePictureImageView: UIImageView!
                @IBOutlet weak var dateTimeLabel: UILabel!
                @IBOutlet weak var postStatusLabel: UILabel!
                @IBOutlet weak var totalLikeLabel: UILabel!
                @IBOutlet weak var totalCommentButton: UIButton!
                */
                
                return cell
            }
        break
        case "instagram":
        print("instagram")
        break
        case "facebook":
            switch (postType!) {
            case "text":
                print("facebook text")
                break
            case "photo":
                print("facebook photo")

                let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.facebookPhotoCell, forIndexPath:indexPath) as! FacebookPhotoCell

                cell.accountNameButton.setTitle(post.valueForKey("name") as? String, forState: UIControlState.Normal)
                cell.postStatusLabel.text = post.valueForKey("postText") as? String
                cell.dateTimeLabel.text = post.valueForKey("timeStamp") as? String


                /*
                @IBOutlet weak var accountNameButton: UIButton!
                @IBOutlet weak var profilePictureImageView: UIImageView!
                @IBOutlet weak var dateTimeLabel: UILabel!
                @IBOutlet weak var postStatusLabel: UILabel!
                @IBOutlet weak var totalLikeLabel: UILabel!
                @IBOutlet weak var totalCommentButton: UIButton!
                */

                return cell


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




