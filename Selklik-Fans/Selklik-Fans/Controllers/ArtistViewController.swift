//
//  ArtistViewController.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 16/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData
import AlamofireImage

class ArtistViewController: UIViewController {

    //MARK: - Variable
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var managedContext: NSManagedObjectContext!
    var userToken:String!
    let userInfo = UserInfo()
    //var allPosts = [Post]()

    //MARK: - IBOutlet
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var artistTableView: UITableView!




    //MARK: - Default Function
    override func viewDidLoad() {
        super.viewDidLoad()
        self.managedContext = appDelegate.coreDataStack.context
        self.userToken = userInfo.getTokenFromCoreData(managedContext)
    slideMenu()


        /*
        Alamofire.request(DataAPI.Router.ArtistList(userToken)).responseJSON(){
            response in

            let json = JSON(response.result.value!)

            print(json)
        }
*/
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: Custom function
    func slideMenu(){
        artistTableView.dataSource = self

        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }


}
