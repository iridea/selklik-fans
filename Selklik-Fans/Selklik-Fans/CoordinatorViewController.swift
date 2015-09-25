//
//  ViewController.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 9/23/15.
//  Copyright © 2015 Selklik. All rights reserved.
//

import UIKit

class CoordinatorViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var joinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        //loginButton.backgroundColor = UIColor.clearColor()
        loginButton.layer.cornerRadius = 23
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        //joinButton.backgroundColor = UIColor.clearColor()
        joinButton.layer.cornerRadius = 23
        joinButton.layer.borderWidth = 1
        joinButton.layer.borderColor = UIColor.whiteColor().CGColor
        
      
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


