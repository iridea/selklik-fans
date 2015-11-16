//
//  PremiumViewController.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 16/11/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData
import AlamofireImage
import ActiveLabel
import MediaPlayer


class PremiumViewController: UIViewController {

    //MARK: - Variable
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var managedContext: NSManagedObjectContext!
    var userToken:String!

    var artistPost = [NSManagedObject]()
    let userInfo = UserInfo()
    let photoInfo = Photo()
    let hud = Hud()

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
        static let premiumPhotoCell = "PremiumPhotoCell"
        static let premiumVideoCell = "PremiumVideoCell"
    }

    func registerNib(){
        var cellNib = UINib(nibName: CellIdentifiers.premiumPhotoCell, bundle: nil)
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

        //TODO: create segue to single premium post
        //self.performSegueWithIdentifier("artistPostToSinglePost", sender: self)
    }

    //Get data from JSON and save to CoreData
    func populateFeed() {

        let postEntity = NSEntityDescription.entityForName("PremiumPost",inManagedObjectContext: managedContext)

        Alamofire.request(DataAPI.Router.ArtistPremiumPost(userToken)).responseJSON(){
            response in

            if let jsonData = response.result.value {

                let json = JSON(jsonData)

                print(json)

                for (_,subJson):(String, JSON) in json["result"] {

                    let newPost = Post(entity: postEntity!,
                        insertIntoManagedObjectContext: self.managedContext)

                    //Standard Data ---------------------------
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
                    //End Standard Data ---------------------------

                    //Check Social Media
                    if let socialMediaType = subJson["social_media"].string {

                        switch socialMediaType {
                        case "premium": //------------PREMIUM------------
                            if let postType = subJson["post_type"].string {
                                switch postType {
                                case "photo":
                                    if let photoStdUrl = subJson["post_photo"]["standard"]["photo_link"].string {
                                        newPost.photoStdUrl = photoStdUrl
                                    }else{
                                        print("Unable to read photo_link")
                                    }

                                    if let photoStdWidth = subJson["post_photo"]["standard"]["photo_width"].string {
                                        newPost.photoStdWidth = Float(photoStdWidth)
                                    }else{
                                        print("Unable to read photo_width")
                                    }

                                    if let photoStdHeight = subJson["post_photo"]["standard"]["photo_height"].string {
                                        newPost.photoStdHeight = Float(photoStdHeight)
                                    }else{
                                        print("Unable to read photo_width")
                                    }

                                    if let totalLike = subJson["likes"].string {

                                        newPost.totalLike = Int(totalLike)
                                    }else{
                                        print("unable to read JSON data likes")
                                    }

                                    if let totalComment = subJson["comments"].string {
                                        newPost.totalComment = Int(totalComment)
                                    }else{
                                        print("unable to read JSON data comments")
                                    }

                                    if let chargeType = subJson["charge_type"].string {
                                        newPost.prChargeType = Int(chargeType)
                                    }else{
                                        print("Unable to read JSON data chargeType")
                                    }

                                    if let likeStatus = subJson["like_status"].string {
                                        newPost.prLikeStatus = Int(likeStatus)
                                    }else{
                                        print("Unable to read JSON data likeStatus")
                                    }

                                    if let purchaseStatus = subJson["status"].int {
                                        newPost.prPurchaseStatus = purchaseStatus
                                    }else{
                                        print("Unable to read JSON data likeStatus")
                                    }

                                    break
                                case "video":
                                    //video url only available when purchase status == 1
                                    if let purchaseStatus = subJson["status"].int {
                                        newPost.prPurchaseStatus = purchaseStatus

                                        if purchaseStatus == 1 {
                                            if let videoStdUrl = subJson["post_video"]["standard"]["video_link"].string {
                                                newPost.videoStdUrl = videoStdUrl
                                            }else{
                                                print("Unable to read videoStdUrl")
                                            }

                                        }

                                    }else{
                                        print("Unable to read JSON data likeStatus")
                                    }

                                    //Thumb -------------------------------
                                    if let videoThumbStdUrl = subJson["post_thumb"]["standard"]["thumb_link"].string {
                                        newPost.videoThumbStdUrl = videoThumbStdUrl
                                    }else{
                                        print("Unable to read thumb_height")
                                    }

                                    if let videoThumbStdWidth = subJson["post_thumb"]["standard"]["thumb_width"].string {
                                        newPost.videoThumbStdWidth = Float(videoThumbStdWidth)
                                    }else{
                                        print("Unable to read thumb_width")
                                    }

                                    if let videoThumbStdHeight = subJson["post_thumb"]["standard"]["thumb_height"].string {
                                        newPost.videoThumbStdHeight = Float(videoThumbStdHeight)
                                    }else{
                                        print("Unable to read thumb_height")
                                    }

                                    //Thumb -------------------------------
                                    if let totalLike = subJson["likes"].string {

                                        newPost.totalLike = Int(totalLike)
                                    }else{
                                        print("unable to read JSON data likes")
                                    }

                                    if let totalComment = subJson["comments"].string {
                                        newPost.totalComment = Int(totalComment)
                                    }else{
                                        print("unable to read JSON data comments")
                                    }

                                    if let chargeType = subJson["charge_type"].string {
                                        newPost.prChargeType = Int(chargeType)
                                    }else{
                                        print("Unable to read JSON data chargeType")
                                    }

                                    if let likeStatus = subJson["like_status"].string {
                                        newPost.prLikeStatus = Int(likeStatus)
                                    }else{
                                        print("Unable to read JSON data likeStatus")
                                    }
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
    
    //Set Selklik icon to the center of navigationbar
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
        hud.showProgressBar("Loading data", true, view: self.viewIfLoaded!)
        
        let fetchRequest = NSFetchRequest(entityName: "PremiumPost")
        let dateSort = NSSortDescriptor(key: "timeStamp", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            if results.count > 0 {
                userInfo.clearPremiumPostFromCoreData(managedContext)
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        //insert to core data the new posts received from server
        populateFeed()
    }
    
    func getFeedFromCoreData() {
        let fetchRequest = NSFetchRequest(entityName: "PremiumPost")
        
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

