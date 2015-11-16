//
//  AppDelegate.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 9/23/15.
//  Copyright © 2015 Selklik. All rights reserved.
//

import UIKit
import ReachabilitySwift
import CoreData
import Alamofire
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let useClosures = false
    var userLocalToken:String?
    let reachability = Reachability.reachabilityForInternetConnection()
    lazy var coreDataStack = CoreDataStack()

    //MARK: - Custom Function

    func setInitialViewController(storyboardName storyboardName:String, storyboardId: String){

        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let initialViewController = storyboard.instantiateViewControllerWithIdentifier(storyboardId)
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()

    }

    private func initialSystem(){

        //2. Check internet exist
        if (useClosures) {  // 2nd loop
            reachability!.whenReachable = {
                reachability in
                if reachability.isReachableViaWiFi() {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }

                self.connectedToInternet()
            }
            reachability!.whenUnreachable = { reachability in
                print("System are not connected to internet")
            }
        }
        else //1st loop
        {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityChanged:",
                name: ReachabilityChangedNotification, object: reachability)
        }

        reachability!.startNotifier()

        // Initial reachability check
        if reachability!.isReachable() {
            if reachability!.isReachableViaWiFi() {
                print("Reachable via WiFi")

            } else {
                print("Reachable via Cellular")

            }

            connectedToInternet()

        } else {
            print("System are not connected to internet")
        }
    }

    func reachabilityChanged(note: NSNotification) {

        let reachability = note.object as! Reachability

        if reachability.isReachable() {
            if reachability.isReachableViaWiFi() {
                print("Network is back!. Reachable via WiFi")
            } else {
                print("Network is back!. Reachable via Cellular")
            }

            connectedToInternet()

        } else {
            print("System are not connected to internet")
        }
    }

    deinit {
        reachability!.stopNotifier()

        if (!useClosures) {
            NSNotificationCenter.defaultCenter().removeObserver(self, name: ReachabilityChangedNotification, object: nil)
        }
    }

    func connectedToInternet(){
        if self.window!.rootViewController is CoordinatorViewController {

            if tokenExistInCoreData() { //if local token exist
                print("Local token exist")

                let headers = ["Content-Type": "application/x-www-form-urlencoded"]
                let parameters = ["token":userLocalToken!]
                let postUrl = API.url + API.version + "user_check"


                Alamofire.request(.POST, postUrl, headers: headers, parameters: parameters).responseJSON { response in


                    let json = JSON(response.result.value!)
                    print(json)
                    if let status = json["status"].bool{
                        if status {
                            print("local token == web token")

                            self.setInitialViewController(storyboardName: "Feed", storyboardId: "feedInitialViewController")
                        } else {
                            print("local token != web token")
                            let viewController = self.window!.rootViewController as! CoordinatorViewController
                            viewController.showButton = true
                            viewController.managedContext = self.coreDataStack.context

                        }
                    }else{
                        print("Fail to get status value from JSON")
                    }
                }

            }else{ //if local token NOT exist
                print("local token NOT exist")
                let viewController = self.window!.rootViewController as! CoordinatorViewController
                viewController.managedContext = coreDataStack.context
            }
        }
    }

    func tokenExistInCoreData() -> Bool {

        var accessStatus = false

        let accessFetch = NSFetchRequest(entityName: "Access")

        do  {
            let result = try coreDataStack.context.executeFetchRequest(accessFetch) as? [SelklikFansAccess]

            if let loginUser = result {

                print("loginUser.count:\(loginUser.count)")

                if loginUser.count == 1 {
                    print("loginUser.count: \(loginUser.count)")

                    if let token = loginUser[0].token {
                        userLocalToken = token
                        print("loginUser[0].token:" + token)
                        accessStatus = true
                    }
                }else{
                    accessStatus = false
                }
            }
        }
        catch let fetchError as NSError {
            print("Fetch access in AppDelegate error: \(fetchError.localizedDescription)")
        }
        return accessStatus
    }

    private func verifyUserToken() -> Bool {
        var status = false
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]
        let parameters = ["token":userLocalToken!, "country":Setting.malaysia]
        let postUrl = API.url + API.version + "user_check"

        Alamofire.request(.POST, postUrl, headers: headers, parameters: parameters).responseJSON { response in

                let json = JSON(response.result.value!)
                print(json.array)
                if let _ = json["status"].bool{
                    print("MASUK")
                    status = true
                }

        }

        print("verifyStatus:\(status)")
        return status
    }

    //MARK: - Default Function

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)

        UIApplication.sharedApplication().registerForRemoteNotifications()


        UINavigationBar.appearance().barStyle = .Black
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()

        initialSystem()


        return true
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {

        let characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )

        Setting.deviceToken = ( deviceToken.description as NSString )
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String

        print("deviceToken:\(Setting.deviceToken)")
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
         NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
    }



    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        
        print(error)
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
} //END OF APPDELEGATE CLASS


