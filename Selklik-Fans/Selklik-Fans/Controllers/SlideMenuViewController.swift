//
//  SlideMenuViewController.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 09/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class SlideMenuViewController: UIViewController {

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var managedContext: NSManagedObjectContext!

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

     let photoInfo = Photo()

    //variable for loading HUD
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()

    @IBAction func logoutButton(sender: AnyObject) {
        logoutFromSystem()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.managedContext = appDelegate.coreDataStack.context
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2
        profileImageView.clipsToBounds = true
        getUserInfoFromCoreData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - Custom Function
    func getUserInfoFromCoreData(){
        var userObject = [NSManagedObject]()
        let fetchRequest = NSFetchRequest(entityName: "User")

        do  {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            userObject = results as! [NSManagedObject]
            let user = userObject[0]
            self.userNameLabel.text = user.valueForKey("firstName") as? String
            self.emailLabel.text = user.valueForKey("email") as? String

            var placeholderImage = UIImage(named: "placeholder")
            let imageSize = CGSize(width: (user.valueForKey("profileImageWidth") as? CGFloat)!, height: ((user.valueForKey("profileImageHeight") as? CGFloat)!)/2.0)

            placeholderImage = self.photoInfo.resize(image: UIImage(named: "placeholder")!, sizeChange: imageSize, imageScale: 0.1)
            let postPhotoUrl = NSURL(string: (user.valueForKey("profileImageUrl") as? String)!)
            self.profileImageView.image = nil
            self.profileImageView.af_setImageWithURL(postPhotoUrl!, placeholderImage: placeholderImage)

        }
        catch let fetchError as NSError {
            print("Fetch access in AppDelegate error: \(fetchError.localizedDescription)")
        }
    }

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

    private func logoutFromSystem() {

        progressBarDisplayer("Logout...", true)

        let headers = ["Content-Type": "application/x-www-form-urlencoded"]

        let userInfo = UserInfo()
        let token = userInfo.getTokenFromCoreData(appDelegate.coreDataStack.context)
        let parameters = ["token":token]

        let postUrl = API.logoutUrl

        Alamofire.request(.POST, postUrl, headers: headers, parameters: parameters).responseJSON { response in

                self.messageFrame.removeFromSuperview()

                let json = JSON(response.result.value!)

                print("json from logout:\(json)")

                if  (json["status"].boolValue){

                    print("Logout Successful")

                    userInfo.removeUserAccessFromCoreData(self.appDelegate.coreDataStack.context)

                    dispatch_async(dispatch_get_main_queue()) {

                        self.messageFrame.removeFromSuperview()
                        self.view.userInteractionEnabled = true
                        let storyboard = UIStoryboard(name: "Startup", bundle: nil)
                        let controller = storyboard.instantiateViewControllerWithIdentifier("InitialStartup") as! CoordinatorViewController
                        controller.managedContext = self.appDelegate.coreDataStack.context
                        controller.showButton = true
                        self.presentViewController(controller, animated: true, completion: nil)
                    }
                }
                else{
                    print("Problem with logout")
                    let uiAlert = UIAlertController(title: Title.logoutFail, message: Message.logoutFail, preferredStyle: UIAlertControllerStyle.Alert)
                    self.presentViewController(uiAlert, animated: true, completion: nil)

                    uiAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
                        self.messageFrame.removeFromSuperview()
                        self.view.userInteractionEnabled = true

                    }))

                }

        }
    }

}
