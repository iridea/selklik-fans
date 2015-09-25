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

class LoginViewController: UIViewController, UITextFieldDelegate {
   
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var textboxBackground: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
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
        
        let username = self.emailTextField.text
        let password = self.passwordTextField.text
        
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]
        
        let parameters = ["email":username!,
            "password":password!]
        
        let postUrl = "http://www.selklik.mobi/api/1.1/user_login"
        
        Alamofire.request(.POST, postUrl, headers: headers, parameters: parameters).responseJSON { _, _, result in
            switch result {
            case .Success:
                print("Validation Successful")
                let json = JSON(result.value!)
                print(json["token"].string!)
            case .Failure(_, let error):
                print(error)
            }
        }
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


