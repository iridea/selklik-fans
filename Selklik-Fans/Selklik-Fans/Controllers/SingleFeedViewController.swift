//
//  SingleFeedViewController.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 21/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData
import AlamofireImage
import ActiveLabel

class SingleFeedViewController: UIViewController {

    //MARK: - Variable
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var managedContext: NSManagedObjectContext!
    var userToken:String!
    var name:String!
    var artistId:String!
    var countryCode:String!
    var profileUrl:String!


    var artistPost = [NSManagedObject]()

    let userInfo = UserInfo()
    let photoInfo = Photo()
    let hud = Hud()
    let messagebox = MessageBox()
    var allPosts = [PostSingle]()


    var selectedImageUrl:String?

    var fetchedResultsController: NSFetchedResultsController!

    //MARK: - Struct
    struct CellIdentifiers {
        static let altTwitterStatusCell = "AltTwitterStatusCell"
        static let altTwitterPhotoCell = "AltTwitterPhotoCell"
        static let altTwitterVideoCell = "AltTwitterVideoCell"

        static let altRetweetStatusCell = "AltRetweetStatusCell"
        static let altRetweetPhotoCell = "AltRetweetPhotoCell"
        static let altRetweetVideoCell = "AltRetweetVideoCell"

        static let altInstagramPhotoCell = "AltInstagramPhotoCell"
        static let altInstagramVideoCell = "AltInstagramVideoCell"

        static let altFacebookStatusCell = "AltFacebookStatusCell"
        static let altFacebookPhotoCell = "AltFacebookPhotoCell"
        static let altFacebookVideoCell = "AltFacebookVideoCell"
    }

    func registerNib(){
         //twitter
       var cellNib = UINib(nibName: CellIdentifiers.altTwitterStatusCell, bundle: nil)
        feedTableView.registerNib(cellNib, forCellReuseIdentifier: CellIdentifiers.altTwitterStatusCell)
        cellNib = UINib(nibName: CellIdentifiers.altTwitterPhotoCell, bundle: nil)
        feedTableView.registerNib(cellNib, forCellReuseIdentifier: CellIdentifiers.altTwitterPhotoCell)
        cellNib = UINib(nibName: CellIdentifiers.altTwitterVideoCell, bundle: nil)
        feedTableView.registerNib(cellNib, forCellReuseIdentifier: CellIdentifiers.altTwitterVideoCell)

        cellNib = UINib(nibName: CellIdentifiers.altRetweetStatusCell, bundle: nil)
        feedTableView.registerNib(cellNib, forCellReuseIdentifier: CellIdentifiers.altRetweetStatusCell)
        cellNib = UINib(nibName: CellIdentifiers.altRetweetPhotoCell, bundle: nil)
        feedTableView.registerNib(cellNib, forCellReuseIdentifier: CellIdentifiers.altRetweetPhotoCell)
        cellNib = UINib(nibName: CellIdentifiers.altRetweetVideoCell, bundle: nil)
        feedTableView.registerNib(cellNib, forCellReuseIdentifier: CellIdentifiers.altRetweetVideoCell)

        cellNib = UINib(nibName: CellIdentifiers.altInstagramPhotoCell, bundle: nil)
        feedTableView.registerNib(cellNib, forCellReuseIdentifier: CellIdentifiers.altInstagramPhotoCell)
        cellNib = UINib(nibName: CellIdentifiers.altInstagramVideoCell, bundle: nil)
        feedTableView.registerNib(cellNib, forCellReuseIdentifier: CellIdentifiers.altInstagramVideoCell)

        cellNib = UINib(nibName: CellIdentifiers.altFacebookStatusCell, bundle: nil)
        feedTableView.registerNib(cellNib, forCellReuseIdentifier: CellIdentifiers.altFacebookStatusCell)
        cellNib = UINib(nibName: CellIdentifiers.altFacebookPhotoCell, bundle: nil)
        feedTableView.registerNib(cellNib, forCellReuseIdentifier: CellIdentifiers.altFacebookPhotoCell)
        cellNib = UINib(nibName: CellIdentifiers.altFacebookVideoCell, bundle: nil)
        feedTableView.registerNib(cellNib, forCellReuseIdentifier: CellIdentifiers.altFacebookVideoCell)
    }

    //MARK: - IBAction
    @IBAction func followButton(sender: AnyObject) {
        updateFollowStatus(true)
    }

    //MARK: - IBOutlet
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var facebookIcon: UIImageView!
    @IBOutlet weak var twitterIcon: UIImageView!
    @IBOutlet weak var instagramIcon: UIImageView!
    @IBOutlet weak var feedTableView: UITableView!

    @IBAction func closeButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    //MARK: - Custom Function

    func reloadSingleFeedDataFromServer(){
        hud.showProgressBar("Loading data", true, view: self.viewIfLoaded!)

        let fetchRequest = NSFetchRequest(entityName: "PostSingle")
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            if results.count > 0 {
                userInfo.clearSingleArtistFeedFromCoreData(managedContext)
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }

        //insert to core data the new posts received from server
        populateSingleFeed()
    }

    func populateSingleFeed() {

        let postEntity = NSEntityDescription.entityForName("PostSingle",inManagedObjectContext: managedContext)

        Alamofire.request(DataAPI.Router.SingleArtistPost(userToken,artistId)).responseJSON(){
            response in

            if let jsonData = response.result.value {

                let json = JSON(jsonData)

                for (_,subJson):(String, JSON) in json["result"] {

                    let newPost = PostSingle(entity: postEntity!,
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

                    if let timestamp = subJson["timestamp"].string {
                        newPost.timeStamp = self.userInfo.stringToDate(timestamp)
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
                    
                    self.getSingleFeedFromCoreData()
                    self.feedTableView.reloadData()
                    
                     self.hud.hideProgressBar()
                    self.view.userInteractionEnabled = true
                }
                
                
            }
            else{ //Unable to read JSON data from Alamofire
                
                print("Unable to read JSON data from Alamofire")
                let uiAlert = UIAlertController(title: "Read json fail", message: "Unable to read JSON data from Alamofire", preferredStyle: UIAlertControllerStyle.Alert)
                self.presentViewController(uiAlert, animated: true, completion: nil)
                
                uiAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
                     self.hud.hideProgressBar()
                    self.view.userInteractionEnabled = true
                    
                }))
            }
            
            
        }// End of Alamofire
        
    } //End of populateFeed()

    func getSingleFeedFromCoreData() {
        let fetchRequest = NSFetchRequest(entityName: "PostSingle")
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


    func updateFollowStatus(followThisArtist:Bool){
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]

        let parameters = [
            "token": userToken,
            "artist_id": artistId
        ]

        print("userToken: \(userToken)")
        print("artistId: \(artistId)")

        let APIUrl = API.url + API.version
        print("APIUrl: \(APIUrl)")
        var postUrl = APIUrl + "user_follow"

        if !followThisArtist {
            postUrl = APIUrl + "user_unfollow"
        }

        Alamofire.request(.POST, postUrl, headers: headers, parameters: parameters).responseJSON { response in


            //Remove HUD
            //self.messageFrame.removeFromSuperview()

            let json = JSON(response.result.value!)

            print(json)

            if  (json["status"].boolValue){

                if (json["result"][0]["follow"]){
                    self.messagebox.showRegisterSuccessfulMessage("Successful", message: "You have successfully follow this artist", buttonTitle: "Close", style: .Success, duration: 0.0, colorStyle: 0x330066 ,buttonTextColor: 0xFFFFFF)
                }
                else {
                    self.messagebox.showRegisterSuccessfulMessage("Fail", message: "You already follow this artist", buttonTitle: "Close", style: .Error, duration: 0.0, colorStyle: 0xFF9933 ,buttonTextColor: 0xFFFFFF)
                }
            }

            /*
            print(json["user"]["firstname"].string)

            if  (json["status"].boolValue){

                print("Validation Successful")

                dispatch_async(dispatch_get_main_queue()) {
                    self.updateOrInsertTokenInCoreData(json["token"].string!)
                    self.performSegueWithIdentifier("loginToFeedSegue", sender: self)
                }
            }
            else{
                print("Validation Failed")
                let uiAlert = UIAlertController(title: Title.loginFail, message: Message.loginFail, preferredStyle: UIAlertControllerStyle.Alert)
                self.presentViewController(uiAlert, animated: true, completion: nil)

                uiAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
                    self.messageFrame.removeFromSuperview()
                    self.view.userInteractionEnabled = true

                }))

            } */

        }
        
    } 

    //MARK: - Default Function
    override func viewDidLoad() {
        super.viewDidLoad()


        feedTableView.rowHeight = UITableViewAutomaticDimension
        feedTableView.estimatedRowHeight = 90

        registerNib()

        feedTableView.dataSource = self
        //feedTableView.delegate = self

        self.managedContext = appDelegate.coreDataStack.context
        self.userToken = userInfo.getTokenFromCoreData(managedContext)

        self.artistImage.layer.cornerRadius = self.artistImage.frame.width / 2
        self.artistImage.clipsToBounds = true

        self.artistImage.af_setImageWithURL(NSURL(string: profileUrl)!)
        self.artistName.text = name
        reloadSingleFeedDataFromServer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
