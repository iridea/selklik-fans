//
//  CommentViewController.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 26/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData
import AlamofireImage

class CommentViewController: UIViewController {

    //MARK: - Variable
    var postId:String!
    var socialMediaType:String!
    var token:String!
    var country:String!

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var managedContext: NSManagedObjectContext!
    var userToken:String!
    let userInfo = UserInfo()
    let hud = Hud()
    var commentObject = [NSManagedObject]()

    //MARK: - IBOutlet
    @IBOutlet weak var commentTableView: UITableView!

    //MARK: - Struct
    struct CellIdentifiers {
        static let commentCell = "CommentCell"
    }

    //MARK: - IBAction
    @IBAction func closeButtonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    //MARK: - Default Function
    override func viewDidLoad() {
        super.viewDidLoad()

        commentTableView.rowHeight = UITableViewAutomaticDimension
        commentTableView.estimatedRowHeight = 74

        self.managedContext = appDelegate.coreDataStack.context
        self.userToken = userInfo.getTokenFromCoreData(managedContext)

        registerNib()

        commentTableView.dataSource = self
        //commentTableView.delegate = self

        clearLocalCommentData()
        populateComments()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Custom Function
    func registerNib(){

        let cellNib = UINib(nibName: CellIdentifiers.commentCell, bundle: nil)
        commentTableView.registerNib(cellNib, forCellReuseIdentifier: CellIdentifiers.commentCell)
    }

    func clearLocalCommentData(){
        hud.showProgressBar("Loading data", true, view: self.viewIfLoaded!)
        userInfo.clearCommentFromCoreData(managedContext)
    }

    func populateComments() {

        let commentEntity = NSEntityDescription.entityForName("Comment",inManagedObjectContext: managedContext)

        Alamofire.request(DataAPI.Router.FeedComment(token,postId,socialMediaType,country)).responseJSON(){
            response in

            if let jsonData = response.result.value {

                let json = JSON(jsonData)

                print(json)


                for (_,subJson):(String, JSON) in json["result"] {

                    let newComment = Comment(entity: commentEntity!,
                        insertIntoManagedObjectContext: self.managedContext)

                    if let screenName = subJson["commenter_screen_name"].string {
                        newComment.screenName = screenName
                    }else{
                        print("unable to read JSON data countryCode")
                    }

                    if let timeStamp = subJson["timestamp"].string {
                        newComment.timeStamp = self.userInfo.stringToDate(timeStamp)
                    }else{
                        print("unable to read JSON data id")
                    }

                    if let postId = subJson["post_id"].string {
                        newComment.postId = postId
                    }else{
                        print("unable to read JSON data country_icon")
                    }

                    if let name = subJson["commenter_name"].string {
                        newComment.name = name
                    }else{
                        print("unable to read JSON data total")
                    }

                    if let profileImageUrl = subJson["commenter_img"].string {
                        newComment.profileImageUrl = profileImageUrl
                    }else{
                        print("unable to read JSON data country_name")
                    }

                    if let comment = subJson["comment_text"].string {
                        newComment.comment = comment
                    }else{
                        print("unable to read JSON data continent")
                    }
                } // End of For-Loop JSON data

                dispatch_async(dispatch_get_main_queue()) {
                    do {
                        try self.managedContext.save()
                    } catch let error as NSError {
                        print("Could not save: \(error)")
                    }

                    self.getCommentCoreData()
                    self.commentTableView.reloadData()

                    self.hud.hideProgressBar()
                    self.view.userInteractionEnabled = true
                }

            }
            else{ //Unable to read JSON data from Alamofire
                print("Unable to read JSON data from Alamofire")
            }
            
        }// End of Alamofire
        
    }

    func getCommentCoreData() {
        let fetchRequest = NSFetchRequest(entityName: "Comment")
        let nameSort =
        NSSortDescriptor(key: "timeStamp", ascending: false)
        fetchRequest.sortDescriptors = [nameSort]
        do  {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            commentObject = results as! [NSManagedObject]

        }
        catch let fetchError as NSError {
            print("Fetch access in AppDelegate error: \(fetchError.localizedDescription)")
        }
    }

}
