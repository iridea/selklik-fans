//
//  SettingViewController.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 19/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import UIKit
import CoreData

class SettingViewController: UIViewController {

    //MARK: - Variable
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var managedContext: NSManagedObjectContext!

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
        }
        else
        {
             print("OFF")
        }
    }

    //MARK: - Custom function
    func getUserInfoFromCoreData(){
        var userObject = [NSManagedObject]()
        let fetchRequest = NSFetchRequest(entityName: "AppSetting")

        do  {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            userObject = results as! [NSManagedObject]
            let user = userObject[0]

            if let status = user.valueForKey("pushNotification") as? NSNumber {
                self.pushNotificationSwitch.setOn(Bool(status), animated:true)
            }

        }
        catch let fetchError as NSError {
            print("Fetch access in AppDelegate error: \(fetchError.localizedDescription)")
        }
    }

    //MARK: - Default function
    override func viewDidLoad() {
        super.viewDidLoad()
        self.managedContext = appDelegate.coreDataStack.context

        whitePanel.layer.cornerRadius = 10
        whitePanel.clipsToBounds = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
