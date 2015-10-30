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
                    print("Could not save token: \(error)")
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

    func saveUserInfo(firstName:String, lastName:String, gender:String, birthday:NSDate,phone:String, country:String, profileImageUrl:String, profileImageWidth:Float, profileImageHeight:Float, email:String){

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
                currentUser.lastName   = lastName
                currentUser.gender     = gender
                currentUser.birthday   = birthday
                currentUser.phone      = phone
                currentUser.country    = country

                currentUser.profileImageUrl    = profileImageUrl
                currentUser.profileImageWidth  = profileImageWidth
                currentUser.profileImageHeight = profileImageHeight

                currentUser.email = email

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
            "device_id": "device_id123"+(userInfo.dateToSting(NSDate()) as String),
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

                //---------------------------------
                var _firstName:String = ""
                var _lastName:String = ""
                var _gender:String = ""
                var _birthday:NSDate = NSDate()
                var _phone:String = ""
                var _country:String = ""
                var _email:String = ""
                var _profileImageUrl:String = ""
                var _profileImageWidth:Float = 0.0
                var _profileImageHeight:Float = 0.0


                if let firstName = json["user"]["firstname"].string{
                    print("firstName: \(firstName)")
                    _firstName = firstName
                }

                if let lastname = json["user"]["lastname"].string{
                    print("lastname: \(lastname)")
                    _lastName = lastname
                }

                if let gender = json["user"]["gender"].string{
                    print("gender: \(gender)")
                    _gender = gender
                }

                if let email = json["user"]["email"].string{
                    print("email: \(email)")
                    _email = email
                }

                if let birthday = json["user"]["birthdate"].string{
                    print("birthday: \(birthday)")
                    _birthday=self.userInfo.stringToDate(birthday, dateFormat: "yyyy-MM-dd")!
                }

                if let phone = json["user"]["phone"].string{
                    print("phone: \(phone)")
                    _phone = phone

                }

                if let country = json["user"]["country"].string{
                    print("country: \(country)")
                    _country = country
                }


                if let photo_link = json["user_photo"]["photo_link"].string{
                    print("photo_link: \(photo_link)")
                    _profileImageUrl = photo_link
                }

                if let photo_width = json["user_photo"]["photo_width"].string{
                    print("photo_width: \(photo_width)")
                    _profileImageWidth = Float(photo_width)!
                }

                if let photo_height = json["user_photo"]["photo_height"].string{
                    print("photo_height: \(photo_height)")
                    _profileImageHeight = Float(photo_height)!
                }

                self.saveUserInfo(_firstName, lastName: _lastName, gender: _gender, birthday: _birthday, phone: _phone, country: _country, profileImageUrl: _profileImageUrl, profileImageWidth: _profileImageWidth, profileImageHeight: _profileImageHeight,email: _email)

                //--------------------------------

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
