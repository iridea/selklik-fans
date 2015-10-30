//
//  ProfileViewController.swift
//  Selklik-Fans
//
//  Created by Jamal N. Ahmad on 17/10/2015.
//  Copyright © 2015 Selklik. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController {

    //MARK: - Variable
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var managedContext: NSManagedObjectContext!

    //MARK: IBOutlet
    @IBOutlet weak var whitePanel: UIView!
    @IBOutlet weak var firstNameLabel: UITextField!
    @IBOutlet weak var lastNameLabel: UITextField!
    @IBOutlet weak var genderLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!

    let photoInfo = Photo()


    //MARK: Custom function
    func getUserInfoFromCoreData(){
        var userObject = [NSManagedObject]()
        let fetchRequest = NSFetchRequest(entityName: "User")

        do  {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            userObject = results as! [NSManagedObject]
            let user = userObject[0]

            if let firstName = user.valueForKey("firstName") as? String {
                self.firstNameLabel.text = firstName
            }

            if let lastName = user.valueForKey("lastName") as? String {
                self.lastNameLabel.text = lastName
            }

            if let gender = user.valueForKey("gender") as? String {
                self.genderLabel.text = gender

            }

            if let email = user.valueForKey("email") as? String {
                self.emailLabel.text = email
            }

            if let profileUrl = user.valueForKey("profileImageUrl") as? String {
                var placeholderImage = UIImage(named: "placeholder")
                let imageSize = CGSize(width: (user.valueForKey("profileImageWidth") as? CGFloat)!, height: ((user.valueForKey("profileImageHeight") as? CGFloat)!)/2.0)

                placeholderImage = self.photoInfo.resize(image: UIImage(named: "placeholder")!, sizeChange: imageSize, imageScale: 0.1)
                let postPhotoUrl = NSURL(string: (profileUrl))
                self.profileImageView.image = nil
                self.profileImageView.af_setImageWithURL(postPhotoUrl!, placeholderImage: placeholderImage)
            }



        }
        catch let fetchError as NSError {
            print("Fetch access in AppDelegate error: \(fetchError.localizedDescription)")
        }
    }

    /*
    func getCountryCoreData() {

    }
    */

    //MARK: Default function
    override func viewDidLoad() {
        super.viewDidLoad()

        self.managedContext = appDelegate.coreDataStack.context
        whitePanel.layer.cornerRadius = 10
        whitePanel.clipsToBounds = true

        profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2
        profileImageView.clipsToBounds = true

        getUserInfoFromCoreData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CloseButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
