//
//  LoginViewController.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 9/24/15.
//  Copyright © 2015 Selklik. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
   
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var textboxBackground: UIView!
    
    //MARK: - Custom Function
    @IBAction func backButtonPress(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        print("textFieldDidBeginEditing")
    mainScrollView.setContentOffset(CGPointMake(0, 20), animated: true)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        mainScrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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


