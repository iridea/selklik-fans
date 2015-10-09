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

class SlideMenuViewController: UIViewController {

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    //variable for loading HUD
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()

    @IBAction func logoutButton(sender: AnyObject) {
        logoutFromSystem()

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - Custom Function

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

        Alamofire.request(.POST, postUrl, headers: headers, parameters: parameters).responseJSON { _, _, result in
            switch result {
            case .Success:

                self.messageFrame.removeFromSuperview()

                let json = JSON(result.value!)

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
            case .Failure(_, let error):
                
                print(error)
            }
        }
    }

}
