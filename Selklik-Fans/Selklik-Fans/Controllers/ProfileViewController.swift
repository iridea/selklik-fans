//
//  ProfileViewController.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 17/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var whitePanel: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        whitePanel.layer.cornerRadius = 10
        whitePanel.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CloseButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
