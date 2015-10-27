//
//  RegisterViewController.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 28/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import UIKit
import SCLAlertView

class RegisterViewController: UIViewController {

    //MARK: - IBAction
    @IBAction func backButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func joinButton(sender: AnyObject) {
        showRegisterSuccessfulMessage()
    }

    //MARK: Custom function
    func showRegisterSuccessfulMessage(){
        SCLAlertView().showTitle(
            "Congratulations", // Title of view
            subTitle: "Operation successfully completed.", // String of view
            duration: 0.0, // Duration to show before closing automatically, default: 0.0
            completeText: "Done", // Optional button value, default: ""
            style: .Success, // Styles - see below.
            colorStyle: 0xA429FF,
            colorTextButton: 0xFFFFFF
        )
    }

    //MARK: Default function
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
