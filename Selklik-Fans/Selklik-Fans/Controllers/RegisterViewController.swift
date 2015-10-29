//
//  RegisterViewController.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 28/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class RegisterViewController: UIViewController {

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var managedContext: NSManagedObjectContext!
    var currentAccess: SelklikFansAccess!

    @IBOutlet weak var firstNameTextField: UITextField!

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    let messagebox = MessageBox()
    let userInfo = UserInfo()
    //MARK: - IBAction
    @IBAction func backButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func joinButton(sender: AnyObject) {
        registerUser()
    }


    //MARK: Custom function

    func updateOrInsertTokenInCoreData(userToken:String) {

        let accessEntity = NSEntityDescription.entityForName("Access",
            inManagedObjectContext: managedContext)

        let accessFetch = NSFetchRequest(entityName: "Access")

        do  {
            let result = try managedContext.executeFetchRequest(accessFetch) as? [SelklikFansAccess]

            if let loginUser = result {

                //if old token exist in core data, delete it
                if loginUser.count > 0 {
                    currentAccess = loginUser[0]
                    clearTokenInCoreData()
                }

                currentAccess = SelklikFansAccess(entity: accessEntity!, insertIntoManagedObjectContext: managedContext)
                currentAccess.token = userToken

                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Could not save: \(error)")
                }
            }
        }
        catch let fetchError as NSError {
            print("dogFetch error: \(fetchError.localizedDescription)")
        }
    }

    func clearTokenInCoreData(){
        managedContext.deleteObject(currentAccess)

        do {
            try managedContext.save()
        } catch let error as NSError {

            print("Could not save: \(error)")
        }
    }

    func saveUserInfo(firstName:String, email:String){

        var currentUser: User!
        let userEntity = NSEntityDescription.entityForName("User",
            inManagedObjectContext: managedContext)

        let userFetch = NSFetchRequest(entityName: "User")

        do  {
            let result = try managedContext.executeFetchRequest(userFetch) as? [User]

            if let loginUser = result {

                //if old token exist in core data, delete it
                if loginUser.count > 0 {
                    self.userInfo.clearUserFromCoreData(managedContext)
                }

                currentUser = User(entity: userEntity!, insertIntoManagedObjectContext: managedContext)

                currentUser.firstName  = firstName
                currentUser.email   = email

                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Could not save: \(error)")
                }
            }

        }
        catch let fetchError as NSError {
            print("dogFetch error: \(fetchError.localizedDescription)")
        }
        
    }

    func registerUser(){

        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]

        let parameters = ["email": self.emailTextField.text!,
            "password": self.passwordTextField.text!,
            "firstname": self.firstNameTextField.text!,
            "device_id": "device_id123",
            "device_os": 1]


        let APIUrl = API.url + API.version
        print("APIUrl: \(APIUrl)")
        let postUrl = APIUrl + "user_register"

        Alamofire.request(.POST, postUrl, headers: headers, parameters: parameters as?
            [String : AnyObject]).responseJSON { response in

            //Remove HUD
            //self.messageFrame.removeFromSuperview()

            let json = JSON(response.result.value!)

            print(json)

            if  (json["status"].boolValue){

                let userToken = json["token"].string
                self.updateOrInsertTokenInCoreData(userToken!)

                    self.messagebox.showRegisterSuccessfulMessage("Successful", message: "You have successfully register with Selklik", buttonTitle: "Ok", style: .Success, duration: 0.0, colorStyle: 0x330066 ,buttonTextColor: 0xFFFFFF)

                    self.performSegueWithIdentifier("RegisterToFeedSegue", sender: self)


            }
            else{
                    let failMessage = json["info"].string
                    self.messagebox.showRegisterSuccessfulMessage("Fail", message: failMessage!, buttonTitle: "Close", style: .Error, duration: 0.0, colorStyle: 0xFF9933 ,buttonTextColor: 0xFFFFFF)
                }
        }
        
    }

    //MARK: Default function
    override func viewDidLoad() {
        super.viewDidLoad()
        self.managedContext = appDelegate.coreDataStack.context

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
