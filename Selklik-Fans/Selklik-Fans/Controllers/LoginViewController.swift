//
//  LoginViewController.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 9/24/15.
//  Copyright © 2015 Selklik. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var textboxBackground: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var managedContext: NSManagedObjectContext!
    var currentAccess: SelklikFansAccess!
    
    //variable for loading HUD
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    //MARK: - Custom Function
    @IBAction func backButtonPress(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        mainScrollView.setContentOffset(CGPointMake(0, 20), animated: true)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        mainScrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func loginToSystem() {
        
        progressBarDisplayer("Verifying...", true)
        
        let username = self.emailTextField.text
        let password = self.passwordTextField.text
        
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]
        
        let parameters = ["email":username!,
            "password":password!]
        
        let postUrl = API.url + API.version + "user_login"
        
        Alamofire.request(.POST, postUrl, headers: headers, parameters: parameters).responseJSON { _, _, result in
            switch result {
            case .Success:
                self.messageFrame.removeFromSuperview()
                let json = JSON(result.value!)
                if  (json["status"]) {
                    print("Validation Successful")
                    self.updateTokenInCoreData(json["token"].string!)
                    print("currentAccess.token!: " + self.currentAccess.token!)
                    
                    self.performSegueWithIdentifier("loginToFeedSegue", sender: self)
                }
                else{
                    print("Validation Failed")
                    let uiAlert = UIAlertController(title: Title.loginFail, message: Message.loginFail, preferredStyle: UIAlertControllerStyle.Alert)
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
    
    func clearTokenInCoreData(){
        managedContext.deleteObject(currentAccess)
        var error: NSError?
        do {
            try managedContext.save()
        } catch let error1 as NSError {
            error = error1
            print("Could not save: \(error)")
        }
    }
    
    func updateTokenInCoreData(userToken:String) {
        
        let accessEntity = NSEntityDescription.entityForName("Access",
            inManagedObjectContext: managedContext)

        let accessFetch = NSFetchRequest(entityName: "Access")

        var error: NSError?


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
                } catch let error1 as NSError {
                    error = error1
                    print("Could not save: \(error)")
                }
            }
        }
        catch let fetchError as NSError {
            print("dogFetch error: \(fetchError.localizedDescription)")
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
    
    @IBAction func loginButtonTouchUpInside(sender: AnyObject) {
        loginToSystem()
    }
    
    //MARK: - Default Function
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 17
        loginButton.layer.borderWidth = 1
        
        textboxBackground.layer.cornerRadius = 10
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


