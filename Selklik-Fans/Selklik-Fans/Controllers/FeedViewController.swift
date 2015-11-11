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
import AlamofireImage
import ActiveLabel
import MediaPlayer

class FeedViewController: UIViewController {

    //MARK: - Variable
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var managedContext: NSManagedObjectContext!
    var userToken:String!

    var artistPost = [NSManagedObject]()
    let userInfo = UserInfo()
    let photoInfo = Photo()

    //Comment variable
    var selectedPostIdComment:String?
    var selectedSocialMediaTypeComment:String?
    var selectedCountryComment:String?

    //Artist single post parameter
    var selectedArtistId:String?
    var selectedArtistCountryCode:String?
    var selectedArtistImageUrl:String?
    var selectedArtistName:String?


    var selectedImageUrl:String?
    var selectedVideoUrl:String?


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
        static let retweetStatusCell = "RetweetStatusCell"
        static let retweetPhotoCell = "RetweetPhotoCell"
        static let retweetVideoCell = "RetweetVideoCell"

        static let facebookStatusCell = "FacebookStatusCell"
        static let facebookPhotoCell = "FacebookPhotoCell"
        static let facebookVideoCell = "FacebookVideoCell"
        static let facebookShareCell = "FacebookShareCell"

        static let instagramPhotoCell = "InstagramPhotoCell"
        static let instagramVideoCell = "InstagramVideoCell"

        static let twitterSingleStatusFeed = "TwitterSingleStatusFeed"

        static let premiumPhotoCell = "PremiumPhotoCell"
        static let premiumVideoCell = "PremiumVideoCell"
    }


    func registerNib(){

        //facebook
        var cellNib = UINib(nibName: CellIdentifiers.facebookPhotoCell, bundle: nil)
        feedTableView.registerNib(cellNib, forCellReuseIdentifier: CellIdentifiers.facebookPhotoCell)
        cellNib = UINib(nibName: CellIdentifiers.facebookVideoCell, bundle: nil)
        feedTableView.registerNib(cellNib, forCellReuseIdentifier: CellIdentifiers.facebookVideoCell)
        cellNib = UINib(nibName: CellIdentifiers.facebookShareCell, bundle: nil)
        feedTableView.registerNib(cellNib, forCellReuseIdentifier: CellIdentifiers.facebookShareCell)


        //twitter
        cellNib = UINib(nibName: CellIdentifiers.twitterStatusCell, bundle: nil)
        feedTableView.registerNib(cellNib, forCellReuseIdentifier: CellIdentifiers.twitterStatusCell)
        cellNib = UINib(nibName: CellIdentifiers.twitterPhotoCell, bundle: nil)
        feedTableView.registerNib(cellNib, forCellReuseIdentifier: CellIdentifiers.twitterPhotoCell)
        cellNib = UINib(nibName: CellIdentifiers.twitterVideoCell, bundle: nil)
        feedTableView.registerNib(cellNib, forCellReuseIdentifier: CellIdentifiers.twitterVideoCell)
        //twitter - Retweet
        cellNib = UINib(nibName: CellIdentifiers.retweetStatusCell, bundle: nil)
        feedTableView.registerNib(cellNib, forCellReuseIdentifier: CellIdentifiers.retweetStatusCell)
        cellNib = UINib(nibName: CellIdentifiers.retweetPhotoCell, bundle: nil)
        feedTableView.registerNib(cellNib, forCellReuseIdentifier: CellIdentifiers.retweetPhotoCell)
        cellNib = UINib(nibName: CellIdentifiers.retweetVideoCell, bundle: nil)
        feedTableView.registerNib(cellNib, forCellReuseIdentifier: CellIdentifiers.retweetVideoCell)


        //instagram
        cellNib = UINib(nibName: CellIdentifiers.instagramPhotoCell, bundle: nil)
        feedTableView.registerNib(cellNib, forCellReuseIdentifier: CellIdentifiers.instagramPhotoCell)
        cellNib = UINib(nibName: CellIdentifiers.instagramVideoCell, bundle: nil)
        feedTableView.registerNib(cellNib, forCellReuseIdentifier: CellIdentifiers.instagramVideoCell)


        //premium
        cellNib = UINib(nibName: CellIdentifiers.premiumPhotoCell, bundle: nil)
        feedTableView.registerNib(cellNib, forCellReuseIdentifier: CellIdentifiers.premiumPhotoCell)
        cellNib = UINib(nibName: CellIdentifiers.premiumVideoCell, bundle: nil)
        feedTableView.registerNib(cellNib, forCellReuseIdentifier: CellIdentifiers.premiumVideoCell)
    }

    @IBAction func reloadButton(sender: AnyObject) {
        reloadFeedDataFromServer()
    }

    //MARK: - Custom Function

    func showArtistSinglePost(sender:ArtistNameButton) {


        selectedArtistId = sender.id
        selectedArtistCountryCode = sender.countryCode
        selectedArtistImageUrl = sender.imageUrl
        selectedArtistName = sender.name

        self.performSegueWithIdentifier("artistPostToSinglePost", sender: self)
    }

    //TODO: Refactor this progressBarDisplayer function
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

    //TODO: Refactor this fuction to another class
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

        Alamofire.request(DataAPI.Router.ArtistPost(userToken)).responseJSON(){
            response in

            if let jsonData = response.result.value {

                let json = JSON(jsonData)

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

                    if let timestamp = subJson["timestamp"].string {
                        newPost.timeStamp = self.userInfo.stringToDate(timestamp,dateFormat: "yyyy-MM-dd H:mm:ss")
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

                    if let country = subJson["country"].string {
                        newPost.country = country
                    }else{
                        print("unable to read JSON data country")
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
                                /*
                                case "status":
                                    print("facebook text")
                                    break
                                */
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

                                    //Thumb
                                    if let videoThumbStdUrl = subJson["post_thumb"]["standard"]["thumb_link"].string {
                                        newPost.videoThumbStdUrl = videoThumbStdUrl

                                    }

                                    if let videoThumbStdWidth = subJson["post_thumb"]["standard"]["thumb_width"].string {//
                                        newPost.videoThumbStdWidth = Float(videoThumbStdWidth)
                                         print("videoThumbStdWidth: \(videoThumbStdWidth)")
                                    }

                                    if let videoThumbStdHeight = subJson["post_thumb"]["standard"]["thumb_height"].string {
                                        newPost.videoThumbStdHeight = Float(videoThumbStdHeight)
                                        print("videoThumbStdWidth: \(videoThumbStdHeight)")
                                    }
                                    break
                                    
                                case "shared":

                                    //if shareType == "link" {
                                        if let fbContentLink = subJson["post_shared"]["standard"]["shared_link"].string {
                                            newPost.fbContentLink = fbContentLink
                                        }else{
                                            print("Unable to read shared_link")
                                        }

                                        if let fbContentLinkImageUrl = subJson["post_shared"]["standard"]["link_photo"].string {
                                            newPost.fbContentLinkImageUrl = fbContentLinkImageUrl
                                        }else{
                                            print("Unable to read link_photo")
                                        }

                                        if let fbContentLinkTitle = subJson["post_shared"]["standard"]["link_title"].string {
                                            newPost.fbContentLinkTitle = fbContentLinkTitle
                                        }else{
                                            print("Unable to read link_title")
                                        }

                                        if let fbContentLinkText = subJson["post_shared"]["standard"]["link_text"].string {
                                            newPost.fbContentLinkText = fbContentLinkText
                                        }else{
                                            print("Unable to read link_text")
                                        }
                                    //}


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


            }
            else{ //Unable to read JSON data from Alamofire

                print("Unable to read JSON data from Alamofire")
                let uiAlert = UIAlertController(title: "Read json fail", message: "Unable to read JSON data from Alamofire", preferredStyle: UIAlertControllerStyle.Alert)
                self.presentViewController(uiAlert, animated: true, completion: nil)

                uiAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
                    self.messageFrame.removeFromSuperview()
                    self.view.userInteractionEnabled = true

                }))
            }


        }// End of Alamofire

    } //End of populateFeed()


    //MARK: - Default Function
//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return UIStatusBarStyle.LightContent
//    }

    func setBrandIconToNavigationController(){
        // 3
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        // 4
        let image = UIImage(named: "selklik-logo-bolder")
        imageView.image = image
        // 5
        navigationItem.titleView = imageView

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        setBrandIconToNavigationController()

        feedTableView.rowHeight = UITableViewAutomaticDimension
        feedTableView.estimatedRowHeight = 66

        registerNib()

        feedTableView.dataSource = self
        feedTableView.delegate = self

        self.managedContext = appDelegate.coreDataStack.context
        self.userToken = userInfo.getTokenFromCoreData(managedContext)

        print("token from viewdidload - Feedview: \(self.userToken)")
        reloadFeedDataFromServer()

    }

    func reloadFeedDataFromServer(){
        self.progressBarDisplayer("Loading data", true)

        let fetchRequest = NSFetchRequest(entityName: "Post")
        let dateSort = NSSortDescriptor(key: "timeStamp", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
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

        let dateSort = NSSortDescriptor(key: "timeStamp", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]

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

//var facebookPostPhoto:UIImage?






