//
//  SettingViewController.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 19/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON

class SettingViewController: UIViewController {

    //MARK: - Variable
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var managedContext: NSManagedObjectContext!
    //var userSetting:AppSetting!
    var userToken:String!
    let userInfo = UserInfo()
    let messagebox = MessageBox()
    var notificationStatus:NSNumber!

    //MARK: - IBOutlet
    @IBOutlet weak var whitePanel: UIView!
    @IBOutlet weak var pushNotificationSwitch: UISwitch!

    //MARK: - IBAction
    @IBAction func closeButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func pushNotificationSwitchValueChanged(sender: AnyObject) {
        if pushNotificationSwitch.on {
            print("ON")
            postSettingInfoToServer(1)
        }
        else
        {
            print("OFF")
            postSettingInfoToServer(0)
        }
    }

    //MARK: - Custom function
    func postSettingInfoToServer(notificationStatus: Int){

        let headers = ["Content-Type": "application/x-www-form-urlencoded"]

        let parameters = ["token":userToken, "notification":notificationStatus]

        let postUrl = API.userSettingUrl

        Alamofire.request(.POST, postUrl, headers: headers, parameters: parameters as?
            [String : AnyObject]).responseJSON {
                response in

                let json = JSON(response.result.value!)

                if  (json["status"].boolValue){
                    self.updateNotificationSettingInCoreData(notificationStatus)
                }else{
                    self.messagebox.showRegisterSuccessfulMessage("Fail", message: json["status"].string!, buttonTitle: "Close", style: .Error, duration: 0.0, colorStyle: 0xFF9933 ,buttonTextColor: 0xFFFFFF)
                }
        }
    }

    func updateNotificationSettingInCoreData(status: NSNumber){

        let fetchRequest = NSFetchRequest(entityName: "AppSetting")

        do {
            let fetchedEntities = try self.managedContext.executeFetchRequest(fetchRequest) as! [AppSetting]
            fetchedEntities.first?.pushNotification = status
        } catch {
            // Do something in response to error condition
        }

        do {
            try self.managedContext.save()
        } catch {
            // Do something in response to error condition
        }
    }

    //MARK: - Default function
    override func viewDidLoad() {
        super.viewDidLoad()

        self.managedContext = appDelegate.coreDataStack.context
        self.userToken = userInfo.getTokenFromCoreData(managedContext)

        notificationStatus = userInfo.getNotificationSettingFromCoreData(managedContext)
        pushNotificationSwitch.setOn(notificationStatus as Bool, animated: true)

        whitePanel.layer.cornerRadius = 10
        whitePanel.clipsToBounds = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
